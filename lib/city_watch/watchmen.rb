module Watchmen
	
	def self.test
		@watchmen.each do |cmd|
			puts "Running #{cmd.name}:"
			puts cmd.data
			puts "Done."
		end
	end
	
	def self.data
		@watchmen.inject({}) do |acc,cmd|
			acc[cmd.name] = cmd.data
			acc
		end
	end
	
	def self.register(cls)
		@watchmen ||= Set.new
		@watchmen << cls
	end
	
end

require 'city_watch/util/watchman'
require 'city_watch/watchmen/sysinfo'
require 'city_watch/watchmen/unicorns'
require 'city_watch/watchmen/nginx'
require 'city_watch/watchmen/cpu_usage'
require 'city_watch/watchmen/disk_usage'
