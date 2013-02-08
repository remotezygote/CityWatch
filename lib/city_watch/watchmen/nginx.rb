class Nginx
	
	include Watchman
	
	def self.data
		out = PS.data.inject({:masters => [], :workers => []}) do |acc,line|
			if line[:command][/^nginx: master/]
				acc[:masters] << line
			end
			if line[:command][/^nginx: worker/]
				acc[:workers] << line
			end
			acc
		end
		
		if `curl -I -silent http://localhost/nginx_status`[/^HTTP\/1.1 200/]
			active, garbage, nums, open = `curl -silent http://localhost/nginx_status`.split("\n")
			accepts, handled, requests = nums.split
			garbage, reading, garbage, writing, garbage, waiting = open.split
			out = out.merge({:active_connections => active.gsub(/.*:/,'').to_i, :accepted => accepts.to_i, :handled => handled.to_i, :requests => requests.to_i, :reading => reading.to_i, :writing => writing.to_i, :waiting => waiting.to_i})
		end
		
		out.merge({:num_masters => out[:masters].count, :num_workers => out[:workers].count, :summary => [:num_masters, :num_workers, :active_connections]})
	end
	
end