module RunCommand
	
	def command_output
		`#{command}`
	end
	
	def command
		@command ||= "#{options[:command]} #{command_line_opts}"
	end
	
	def command_line_opts
		options.inject([]) do |acc,(k,v)|
			acc << "-#{k} #{v}"
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
	
	class ClassMethods
		
		def set_opts(opts={})
			@opts = defaults.merge(opts)
			@command = nil
		end
		alias_method :defaults, :set_opts
		
		def options
			@opts ||= set_opts
		end
		
		def default_options
			@defaults
		end
		
		def command(cmd,opts={})
			options[:command] = cmd
			defaults opts
		end
		
	end
	
	def self.included(base)
		base.extend(ClassMethods)
		Commands.register(base)
	end
	
end