class Unicorns
	
	include Watchman
	
	def self.data
		out = PS.data.inject({:masters => [], :workers => []}) do |acc,line|
			if line[:command][/^start master/]
				acc[:masters] << line
			end
			if line[:command][/^start worker/]
				acc[:workers] << line
			end
			acc
		end
		out.merge({:num_masters => out[:masters].count, :num_workers => out[:workers].count, :summary => [:num_masters, :num_workers]})
	end
	
end