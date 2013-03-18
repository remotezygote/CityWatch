class Home
	
	include Renderer
	
	def call(env)
		[200,{"Content-Type" => "text/html"},[render("home")]]
	end
	
	def servers
		Reader.servers
	end
	
	Routes.add_route new, { :request_method => 'GET', :path_info => %r{^/$} }, {}, :home
	
end