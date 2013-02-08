class Nginx
	
	include Watchman
	
	def self.data
		out = {:masters => [], :workers => []}
		PS.data.select do |line|
			if line[:command][/^nginx: master/]
				out[:masters] << line
			end
			if line[:command][/^nginx: worker/]
				out[:workers] << line
			end
		end
		out
	end
	
end