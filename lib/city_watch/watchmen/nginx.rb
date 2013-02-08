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
		
		require 'net/http'
		require 'net/https'
		uri = URI.parse("http://localhost/nginx_status")
		http = Net::HTTP.new(uri.host, uri.port)
		req = Net::HTTP::Get.new(uri.path)
		resp = http.request(req)
		case resp
			when Net::HTTPSuccess
				active, garbage, nums, open = resp.read_body.split("\n")
				accepts, handled, requests = nums.split
				garbage, reading, garbage, writing, garbage, waiting = open.split
				out.merge({:active_connections => active.gsub(/.*:/,''), :accepted => accepts, :handled => handled, :requests => requests, :reading => reading, :writing => writing, :waiting => waiting})
		end
		
		out.merge({:num_masters => out[:masters].count, :num_workers => out[:workers].count, :summary => [:num_masters, :num_workers, :active_connections]})
	end
	
end