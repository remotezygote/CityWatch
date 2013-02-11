module Flags
	module ClassMethods
		
		def set_flag(name)
			unless get_flag(name)
				flag_flapped name, :on
				CityWatch.redis.setbit "#{CityWatch.config[:prefix]}::#{host}::#{self.name}::flags", flag_position(name), 1
			end
		end
		
		def clear_flag(name)
			if get_flag(name)
				flag_flapped name, :off
				CityWatch.redis.setbit "#{CityWatch.config[:prefix]}::#{host}::#{self.name}::flags", flag_position(name), 0
			end
		end
		
		def flag_flapped(name,new_val)
			puts "Flag flipped: #{name} -> #{new_val}" if CityWatch.debug?
		end
		
		def get_flag(name,host=host)
			@host = host
			CityWatch.redis.getbit("#{CityWatch.config[:prefix]}::#{host}::#{self.name}::flags", flag_position(name)) == 1 ? true : false
		end
		
		def get_flags(host=host)
			@host = host
			out = []
			map = flag_map
			map.each_index do |idx|
				out << map[idx] if get_flag(map[idx])
			end
			out
		end
		
		def flag_map_key
			"#{CityWatch.config[:prefix]}::#{self.name}::flag_map"
		end
		
		def flag_map
			CityWatch.redis.lrange flag_map_key, 0, -1
		end
		
		def flag_position(name)
			if (map = flag_map) && map.include?(name.to_s)
				map.index(name.to_s)
			else
				new_flag(name)
			end
		end
		
		def new_flag(name)
			CityWatch.redis.rpush(flag_map_key, name) - 1
		end
		
	end
	
	def self.included(base)
		base.extend(ClassMethods)
	end
	
end