class Unicorns
	
	include Watchman
	
	def self.data
		out = {:masters => [], :workers => []}
		PS.data.select do |line|
			if line[:command][/^start master/]
				out[:masters] << line
			end
			if line[:command][/^start worker/]
				out[:workers] << line
			end
		end
		out
	end
	
end