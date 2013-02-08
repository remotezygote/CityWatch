module CityWatch
	
	def self.configure
		require 'optparse'
		options = {
			:config_file => "/etc/#{File.basename($0)}.conf",
		}
		OptionParser.new do |opts|
		  opts.banner = "Usage: city_watch [options]"
		  opts.on("-c", "--config [FILE]", "Specify config file.") do |config|
		    options[:config_file] = config
		  end
		end.parse!
		
		if File.exists?(options[:config_file])
			require 'yaml'
			config.merge!(YAML.load(IO.read(options[:config_file])) || {})
		end
		
		puts config if debug?
		
	end
	
	def self.config
		@config ||= {
			:watch_collector => "localhost:62000",
			:watch_commander => "localhost:62001",
			:environment => "development",
			:prefix => "CityWatch",
			:redis => {}
		}
	end
	
	def self.debug?
		config[:debug] || false
	end
	
	def self.unicorn_opts(rackup_opts)
		unless config[:unicorn]
			if config[File.basename($0).to_sym]
				config[:unicorn] = {:port => config[File.basename($0).to_sym].gsub(/.*:/,'')}
			end
		end
		if config[:unicorn]
			if config[:unicorn][:port]
				rackup_opts[:port] = config[:unicorn][:port]
				rackup_opts[:set_listener] = true
			end
			rackup_opts[:daemonize] = config[:unicorn][:config_file] || false
			rackup_opts[:options][:config_file] = config[:unicorn][:config_file] if config[:unicorn][:config_file]
		end
	end
	
	def self.redis
		require 'redis'
		@redis ||= ::Redis.new(config_opts(config[:redis], :path, :db, :password))
	end
	
	def self.config_opts(conf,*opts)
		opts.inject({}) do |a,k|
			a[k] = conf[k]
			a
		end
	end
	
	
	
end

CityWatch.configure if ARGV[0]