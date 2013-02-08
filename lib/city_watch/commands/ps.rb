class PS
	
	include RunCommand
	
	command :ps
	
	def command_line_opts
		"aux"
	end
	
	def data
		headers = false
		command_output.split("\n").map {|line| line.split("\s") }.inject([]) do |output,line|
			if !headers
				headers = line.map {|hdr| hdr.downcase.to_sym}
			else
				pkt = {}
				cmd = line.slice!(10,line.size-1)
				line << cmd.join(" ")
				line.each_with_index do |itm,idx|
					pkt[headers[idx]] = itm
				end
				output << pkt
			end
			output
		end
	end
	
end