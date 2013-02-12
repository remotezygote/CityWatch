require 'city_watch/util/alerts'
require 'city_watch/util/rules'
require 'city_watch/util/flags'
require 'city_watch/util/notifications'
require 'city_watch/util/datasets'
require 'city_watch/util/status'

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
			run_dataset_collector(dat)
			send_alerts!
			return 0, sum || nil
		end
		
		def host
			@host || nil
		end
		
		def rcv_time
			@rcv_time || Time.now.to_i
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
		base.extend(Alerts)
		base.extend(Rules)
		base.extend(Flags)
		base.extend(Notifications)
		base.extend(DataSets)
		base.extend(Status)
		base.extend(ClassMethods)
		Watchmen.register(base)
	end
	
end