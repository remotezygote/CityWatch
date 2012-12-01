class PS
	
	include RunCommand
	
	command :ps, :fe => ""
	
	def data
		headers = false
		output = []
		command_output.split("\n").map {|line| line.split("\s") }.each do |line|
			if !headers
				headers = line.map {|hdr| hdr.downcase.to_sym}
				next
			end
			next unless headers
			pkt = {}
			cmd = line.slice!(7,line.size-1)
			line << cmd.join(" ")
			line.each_with_index do |itm,idx|
				pkt[headers[idx]] = itm
			end
			output << pkt
		end
		output
	end
	
end