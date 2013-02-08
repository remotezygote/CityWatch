class ResendRequest
	
	def call(env)
		
		post_data = begin Yajl::Parser.new(:symbolize_keys => true).parse(env["rack.input"].read) || {} rescue {} end
		post_data[:received_at] = Time.now.to_s
		
		CityWatch.redis.sadd "#{CityWatch.config[:prefix]}::known_hosts", post_data[:hostname]
		CityWatch.redis.zadd "#{CityWatch.config[:prefix]}::#{post_data[:hostname]}::raw_stats", Time.now.to_i, Yajl::Encoder.encode(post_data)
		
		summary = {}
		
		post_data[:watchmen].each do |watchman,dat|
			CityWatch.redis.zadd "#{CityWatch.config[:prefix]}::#{post_data[:hostname]}::#{watchman}", Time.now.to_i, Yajl::Encoder.encode(dat.merge({:received_at => post_data[:received_at]}))
			if dat[:summary]
				sum = dat[:summary].is_a?(Array) ? dat[:summary].inject({}) {|acc,k| acc[k.to_sym] = dat[k.to_sym]; acc} : dat[:summary]
				CityWatch.redis.zadd "#{CityWatch.config[:prefix]}::#{post_data[:hostname]}::#{watchman}::summary", Time.now.to_i, Yajl::Encoder.encode(sum)
				summary[watchman] = sum
			end
		end
		
		CityWatch.redis.zadd "#{CityWatch.config[:prefix]}::#{post_data[:hostname]}::summary", Time.now.to_i, Yajl::Encoder.encode(summary.merge({:received_at => post_data[:received_at]}))
		
		[200,{"Content-Type" => "text/plain"},["Got it!"]]
	end
	
	Routes.add_route new, { :request_method => 'POST', :path_info => %r{^/receive} }, {}, :receive_data
	
end