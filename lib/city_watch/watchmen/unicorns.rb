class Unicorns
	
	include Watchman
	
	def self.data
		out = PS.data.inject({:masters => [], :workers => [], :master_memory => 0, :worker_memory => 0, :total_memory => 0}) do |acc,line|
			if line[:command][/^start master/]
				acc[:masters] << line
				acc[:master_memory] += line[:rss].to_i
				acc[:total_memory] += line[:rss].to_i
			end
			if line[:command][/^start worker/]
				acc[:workers] << line
				acc[:worker_memory] += line[:rss].to_i
				acc[:total_memory] += line[:rss].to_i
			end
			acc
		end
		out.merge({:num_masters => out[:masters].count, :num_workers => out[:workers].count, :summary => [:num_masters, :num_workers]})
	end
	
	add_rule(:high_memory_usage) do |dat|
		
	end
	
end