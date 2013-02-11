module Watchman
	
	def data
		{}
	end
	
	module ClassMethods
		
		def process(dat,rcv,host)
			@host = host
			@rcv_time = rcv
			CityWatch.redis.zadd "#{CityWatch.config[:prefix]}::#{host}::#{self.name}", rcv_time, Yajl::Encoder.encode(dat.merge({:received_at => dat[:received_at]}))
			if dat[:summary]
				sum = dat[:summary].is_a?(Array) ? dat[:summary].inject({}) {|acc,k| acc[k.to_sym] = dat[k.to_sym]; acc} : dat[:summary]
				CityWatch.redis.zadd "#{CityWatch.config[:prefix]}::#{host}::#{self.name}::summary", rcv_time, Yajl::Encoder.encode(sum)
			end
			run_rules(dat)
			return 0, sum || nil
		end
		
		def host
			@host || nil
		end
		
		def rcv_time
			@rcv_time || Time.now.to_i
		end
		
		def add_rule(name,&block)
			@rules ||= {}
			@rules[name] = block
		end

		def run_rules(dat)
			@rules.map do |(name,rule)|
				rule.call(dat)
			end if @rules
		end
		
		def send_alert(message,dat=nil)
			CityWatch.redis.zadd "#{CityWatch.config[:prefix]}::#{host}::#{self.name}::alerts", rcv_time, Yajl::Encoder.encode({:message => message, :data => dat, :when => rcv_time})
		end
		
		def alerts
			@alerts ||= []
			if block_given?
				@alerts.each do |a|
					yield a
				end
			else
				@alerts
			end
			nil
		end
		
		def get_alerts(host=host,num=5)
			CityWatch.redis.zrevrange "#{CityWatch.config[:prefix]}::#{host}::#{self.name}::alerts", 0, num - 1
		end
		
		def send_alerts!
			@alerts.map do |alert|
				puts "Alert: #{alert.inspect}" #if CityWatch.debug?
			end if @alerts
		end
		
		def set_flag(name)
			unless get_flag(name)
				flag_flapped name, :on
			end
			CityWatch.redis.setbit "#{CityWatch.config[:prefix]}::#{host}::#{self.name}::flags", flag_position(name), 1
		end
		
		def clear_flag(name)
			if get_flag(name)
				flag_flapped name, :off
			end
			CityWatch.redis.setbit "#{CityWatch.config[:prefix]}::#{host}::#{self.name}::flags", flag_position(name), 0
		end
		
		def flag_flapped(name,new_val)
			# should have some event to watch for a flag switching position
			puts "Flag flipped: #{name} -> #{new_val}" #if CityWatch.debug?
		end
		
		def get_flag(name,host=host)
			@host = host
			CityWatch.redis.getbit("#{CityWatch.config[:prefix]}::#{host}::#{self.name}::flags", flag_position(name)) ? true : false
		end
		
		def get_flags(host=host)
			@host = host
			out = {}
			map = flag_map
			map.each_index do |idx|
				out[map[idx]] = get_flag(map[idx])
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
		
		def set_default(k,val)
			opts[k] = val
		end
		
		def opts
			@options ||= {}
		end
		
		def options(*args)
			if args.count > 1
				return args.map {|k| opts[k]}
			else
				return opts[args.first]
			end
			return nil
		end
		alias_method :option, :options
		
	end
	
	def self.included(base)
		base.extend(ClassMethods)
		Watchmen.register(base)
	end
	
end