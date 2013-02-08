class ResendRequest
	
	def call(env)
		
		output = "Known servers:\n\n"
		
		CityWatch.redis.smembers("#{CityWatch.config[:prefix]}::known_hosts").each do |server|
			output << "#{server}: ".ljust(20) << CityWatch.redis.zrevrange("#{CityWatch.config[:prefix]}::#{server}::summary",0,0).first << "\n"
		end
		
		[200,{"Content-Type" => "text/plain"},[output]]
	end
	
	Routes.add_route new, { :request_method => 'GET', :path_info => %r{^/} }, {}, :home
	
end