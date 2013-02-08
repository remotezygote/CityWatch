require 'city_watch/commander'

CityWatch::Routes.freeze

app = Rack::Builder.new do
	
	Rack::Utils.key_space_limit = 123456789
	
	run CityWatch::Routes
	
end

run app