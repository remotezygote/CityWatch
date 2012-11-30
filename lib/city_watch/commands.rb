module Commands
	
	require 'city_watch/util/run_command'
	require 'city_watch/commands/ps'
	require 'city_watch/commands/mpstat'
	# require 'city_watch/commands/iostat'
	# require 'city_watch/commands/sar'
	# require 'city_watch/commands/netstat'
	
	def self.test
		command_list.each do |cmd|
			puts "Running #{cmd.name}:"
			puts cmd.data
			puts "Done."
		end
	end
	
	def self.register(cls)
		command_list << cls
	end
	
	def self.command_list
		@cmd_list ||= []
	end
	
end
