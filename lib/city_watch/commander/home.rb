class Home
	
	def call(env)
		
		output = "<html><body><h1>Known servers:</h1><ul>"
		CityWatch.redis.smembers("#{CityWatch.config[:prefix]}::known_hosts").each do |server|
			output << "<li><a href="">#{server}</a>: <pre>" << CityWatch.redis.zrevrange("#{CityWatch.config[:prefix]}::#{server}::summary",0,0).first << "</pre></li>"
		end
		output << "</ul></body></html>"
		
		[200,{"Content-Type" => "text/html"},[output]]
	end
	
	Routes.add_route new, { :request_method => 'GET', :path_info => %r{^/} }, {}, :home
	
end