module Commands
	
	def self.test
		@command_list.each do |cmd|
			puts "Running #{cmd.name}:"
			puts cmd.data.inspect
			puts "Done."
		end
	end
	
	def self.data
		@command_list.inject({}) do |acc,cmd|
			acc[cmd.name] = cmd.data
		end
	end
	
	def self.register(cls)
		@command_list ||= []
		@command_list << cls
	end
	
end

require 'city_watch/util/run_command'
require 'city_watch/commands/ps'
require 'city_watch/commands/mpstat'
# require 'city_watch/commands/netstat'
# require 'city_watch/commands/iostat'
