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
			CityWatch.redis.sadd "#{CityWatch.config[:prefix]}::#{host}::watchmen", self.name
			CityWatch.redis.zadd "#{CityWatch.config[:prefix]}::#{host}::#{self.name}", rcv_time, Yajl::Encoder.encode(dat.merge({:received_at => dat[:received_at]}))
			if dat[:summary]
				sum = dat[:summary].is_a?(Array) ? dat[:summary].inject({}) {|acc,k| acc[k.to_sym] = dat[k.to_sym]; acc} : dat[:summary]
				CityWatch.redis.zadd "#{CityWatch.config[:prefix]}::#{host}::#{self.name}::summary", rcv_time, Yajl::Encoder.encode(sum)
			end
			run_post_processors!(dat,rcv,host)
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
			@options ||= get_watchman_options
		end
		
		def options(*args)
			if args.count > 1
				return args.map {|k| opts[k] }
			else
				return opts[args.first]
			end
			return nil
		end
		alias_method :option, :options
		
		def run_post_processors!(dat,rcv,host)
			@post_processors.each do |proc|
				proc.call(dat,rcv,host)
			end if @post_processors
		end
		
		def add_post_processor(meth=nil,&block)
			@post_processors ||= []
			@post_processors << (block_given? ? block : meth)
		end
		
		def get_watchman_options
			CityWatch.config[:watchmen] && CityWatch.config[:watchmen][self.name.to_sym] ? CityWatch.config[:watchmen][self.name.to_sym] : {}
		end
		
	end
	
	def self.included(base)
		base.extend(ClassMethods)
		base.extend(Alerts)
		base.add_post_processor base.method(:send_alerts!)
		base.extend(Rules)
		base.add_post_processor base.method(:run_rules)
		base.extend(Flags)
		base.extend(Notifications)
		base.extend(DataSets)
		base.add_post_processor base.method(:run_dataset_collector)
		base.extend(Status)
		Watchmen.register(base)
	end
	
end