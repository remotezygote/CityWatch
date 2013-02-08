class Server
	
	def call(env)
		
		parms = Rack::Request.new(env).params.merge(env["rack.routing_args"]).inject({}){|acc,(k,v)| acc[k.to_sym] = v; acc}
		server = parms[:server]
		
		output = CityWatch.header << '<h1>' << server << "</h1><ul>"
		CityWatch.redis.zrevrange("#{CityWatch.config[:prefix]}::#{server}::raw_stats",0,100).each do |update|
			dat = Yajl::Parser.new(:symbolize_keys => true).parse(update)
			output << "<li><h4>" << dat[:received_at] << "</h4><ul>"
			dat[:watchmen].each do |name,datr|
				output << "<li><strong>" << name.to_s << ":</strong> <pre><code>" << Yajl::Encoder.encode(datr,:pretty => true, :indent => "   ") << "</code></pre></li>"
			end
			output << "</ul></li>"
		end
		output << "</ul></body></html>"
		
		[200,{"Content-Type" => "text/html"},[output]]
	end
	
	Routes.add_route new, { :request_method => 'GET', :path_info => %r{^/(?<server>[\w\.]+)$} }, {}, :server
	
end