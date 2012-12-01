module RunCommand
	
	def command_output
		unless `which #{options[:command]}` == ""
			puts "Running `#{command_line}`..."
			`#{command_line}`
		else
			puts "Command not present: #{options[:command]} (Skipping)"
			""
		end
	end
	
	def command_line
		@command ||= "#{options[:command]} #{command_line_opts}#{options[:grep] && " | fgrep #{options[:grep]}"}"
	end
	
	def command_line_opts
		options.inject([]) do |acc,(k,v)|
			acc << "-#{k} #{v}" unless [:command, :grep].include?(k)
			acc
		end.join(" ")
	end
	
	def options
		@opts ||= self.class.options
	end
	
	def set_opts(opts={})
		@opts = self.class.options.merge(opts)
		@command = nil
	end
	
	def data
		headers = false
		output = []
		command_output.split("\n").map {|line| v = line.split("\s"); v.shift; v }.each do |line|
			if !headers
				headers = line.map {|hdr| hdr.downcase.to_sym}
				next
			end
			next unless headers
			pkt = {}
			line.each_with_index do |itm,idx|
				pkt[headers[idx]] = itm
			end
			output << pkt
		end
		output
	end
	
	module ClassMethods
		
		def set_opts(opts={})
			@opts = options.merge(opts)
			@command = nil
		end
		
		def options
			@opts ||= {}
		end
		
		def command(cmd,opts={})
			options[:command] = cmd
			set_opts opts
		end
		
		def grep(str)
			options[:grep] = str
		end
		
		def data
			new.data
		end
		
	end
	
	def self.included(base)
		base.extend(ClassMethods)
		Commands.register(base)
	end
	
end