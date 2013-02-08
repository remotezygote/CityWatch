class Home
	
	def call(env)
		
		output = CityWatch.header << '<h1>Known servers:</h1><ul>'
		CityWatch.redis.smembers("#{CityWatch.config[:prefix]}::known_hosts").each do |server|
			output << "<li><a href=\"/" << server << "\">#{server}</a>: <pre><code>" << Yajl::Encoder.encode(Yajl::Parser.parse(CityWatch.redis.zrevrange("#{CityWatch.config[:prefix]}::#{server}::summary",0,0).first),:pretty => true, :indent => "   ") << "</code></pre></li>"
		end
		output << "</ul></body></html>"
		
		[200,{"Content-Type" => "text/html"},[output]]
	end
	
	Routes.add_route new, { :request_method => 'GET', :path_info => %r{^/$} }, {}, :home
	
end