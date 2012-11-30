class MPstat
	
	include RunCommand
	
	command :mpstat, :interval => 5, :times => 2
	
	def command_line_opts
		"#{options[:interval]} #{options[:times]}"
	end
	
	def data
		output = []
		command_output.split("\n").map {|line| v = line.split("\s"); v.shift; v }.each do |line|
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
		end
		output
	end
	
end