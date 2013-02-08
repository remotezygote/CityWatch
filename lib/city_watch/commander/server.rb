class Server
	
	def call(env)
		
		parms = Rack::Request.new(env).params.merge(env["rack.routing_args"]).inject({}){|acc,(k,v)| acc[k.to_sym] = v; acc}
		server = parms[:server]
		
		output = "<html><body><h1>" << server << "</h1><ul>"
		CityWatch.redis.zrevrange("#{CityWatch.config[:prefix]}::#{server}::raw_stats",0,100).each do |update|
			output << "<li><pre>" << update << "</pre></li>"
		end
		output << "</ul></body></html>"
		
		[200,{"Content-Type" => "text/html"},[output]]
	end
	
	Routes.add_route new, { :request_method => 'GET', :path_info => %r{^/(?<server>[\w]+)$} }, {}, :server
	
end