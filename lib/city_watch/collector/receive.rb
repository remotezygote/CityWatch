class ResendRequest
	
	def call(env)
		
		post_data = begin Yajl::Parser.new(:symbolize_keys => true).parse(env["rack.input"].read) || {} rescue {} end
		post_data[:received_at] = Time.now.to_s
		
		require 'redis'
		redis = Redis.new
		redis.sadd "#{CityWatch.config[:prefix]}::known_hosts", post_data[:hostname]
		redis.zadd "#{CityWatch.config[:prefix]}::#{post_data[:hostname]}::raw_stats", Time.now.to_i, Yajl::Encoder.encode(post_data)
		
		[200,{"Content-Type" => "text/plain"},["Got it!"]]
	end
	
	Routes.add_route new, { :request_method => 'POST', :path_info => %r{^/receive} }, {}, :receive_data
	
end