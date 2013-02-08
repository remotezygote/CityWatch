class MPstat
	
	include RunCommand
	
	command :mpstat, :interval => 5, :times => 2
	
	def command_line_opts
		"#{options[:interval]} #{options[:times]}"
	end
	
	def data
		command_output.split("\n").map {|line| line.split("\s") }.inject([]) do |output,line|
			if line[1] == "CPU"
				headers = line.map {|hdr| hdr.gsub(/%/,'').to_sym}
				next
			end
			next unless headers
			pkt = {}
			line.each_with_index do |itm,idx|
				pkt[headers[idx]] = itm
			end
			output << pkt
			output
		end
	end
	
end