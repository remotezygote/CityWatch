class Netstat
	
	include RunCommand
	
	command :netstat, :naplev => ""
	
	def data
		headers = false
		output = {}
		command_output.split("\n").each do |line|
			if line[/^Active /,0]
				type = line.split(" ")[1]
			end
			if line[/^Proto /,0]
				fmt = line.split(/ \b/).map {|v| [v.strip.downcase.to_sym,v.length]}
				fmt[fmt.size-1][1] = 99
				next
			end
			next unless fmt
			pkt = {}
			fmt.each do |(name,length)|
				val = line.slice!(0..length-1).strip
				pkt[name] = val
			end
			output[type] ||= []
			output[type] << pkt
		end
		output
	end
	
end