module Watchmen
	
	def self.test
		@watchmen.each do |cmd|
			puts "Running #{cmd.name}:"
			puts cmd.data
			puts "Done."
		end
	end
	
	def self.data
		@watchmen.inject({}) do |acc,watchman|
			if !CityWatch.config[:watchmen] || (CityWatch.config[:watchmen].is_a?(Array) && CityWatch.config[:watchmen].include?(watchman.name.to_sym)) || (CityWatch.config[:watchmen].is_a?(Hash) && CityWatch.config[:watchmen][watchman.name.to_sym])
				acc[watchman.name] = watchman.data
			end
			acc
		end
	end
	
	def self.register(cls)
		@watchmen ||= []
		@watchmen << cls
	end
	
	def self.get(name)
		@watchmen.select {|w| w.name.to_s == name.to_s }.first
	end
	
	def self.each
		@watchmen.each do |w|
			yield w
		end
	end
	
end

require 'city_watch/util/watchman'
require 'city_watch/watchmen/sysinfo'
require 'city_watch/watchmen/unicorns'
require 'city_watch/watchmen/nginx'
require 'city_watch/watchmen/cpu_usage'
require 'city_watch/watchmen/disk_usage'
require 'city_watch/watchmen/uptime'
require 'city_watch/watchmen/redis'
