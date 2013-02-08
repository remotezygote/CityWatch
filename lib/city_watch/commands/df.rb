class DF
	
	include RunCommand
	
	command :df, :k => ""
	
	def data
		headers = false
		output = []
		command_output.split("\n").map {|line| line.split("\s") }.each do |line|
			if !headers
				headers = line.map {|hdr| hdr.downcase.to_sym}
				headers.pop
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