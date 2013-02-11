class WatchCollector
	
	def call(env)
		
		post_data = begin Yajl::Parser.new(:symbolize_keys => true).parse(env["rack.input"].read) || {} rescue {} end
		post_data[:received_at] = Time.now.to_s
		
		Collector.process(post_data)
		
		[200,{"Content-Type" => "text/plain"},["Got it!"]]
	end
	
	Routes.add_route new, { :request_method => 'POST', :path_info => %r{^/receive} }, {}, :receive_data
	
end