class Server
	
	def call(env)
		
		parms = Rack::Request.new(env).params.merge(env["rack.routing_args"]).inject({}){|acc,(k,v)| acc[k.to_sym] = v; acc}
		server = parms[:server]
		
		output = CityWatch.header << '<h1>' << server << "</h1>"
		Watchmen.each do |watchman|
			flags = watchman.get_flags(server)
			alerts = watchman.get_alerts(server,2)
			if (flags && flags.keys.count > 0) || (alerts && alerts.count > 0)
				output << "<h3>" << watchman.name.to_s << "</h3><ul>"
				if flags && flags.keys.count > 0
					output << "<li class=\"alert\"><strong>Flags:</strong> <pre><code>" << Yajl::Encoder.encode(flags,:pretty => true, :indent => "   ") << "</code></pre></li>"
				end
				if alerts && alerts.count > 0
					output << "<li class=\"alert\"><strong>Alerts:</strong></li>"
					alerts.each do |alert|
						output << "<li><pre><code>" << Yajl::Encoder.encode(Yajl::Parser.parse(alert),:pretty => true, :indent => "   ") << "</code></pre></li>"
					end
				end
				output << "</ul>"
			end
		end
		output << "<ol>"
		CityWatch.redis.zrevrange("#{CityWatch.config[:prefix]}::#{server}::raw_stats",0,10).each do |update|
			dat = Yajl::Parser.new(:symbolize_keys => true).parse(update)
			output << "<li><h4>" << dat[:received_at] << "</h4><ul>"
			dat[:watchmen].each do |name,datr|
				output << "<li><strong>" << name.to_s << ":</strong> <pre><code>" << Yajl::Encoder.encode(datr,:pretty => true, :indent => "   ") << "</code></pre></li>"
			end
			output << "</ul></li>"
		end
		output << "</ol></body></html>"
		
		[200,{"Content-Type" => "text/html"},[output]]
	end
	
	Routes.add_route new, { :request_method => 'GET', :path_info => %r{^/(?<server>[\w\.]+)$} }, {}, :server
	
end