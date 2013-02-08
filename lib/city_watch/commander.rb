require 'rack/mount'

module CityWatch
  Routes = Rack::Mount::RouteSet.new
end

::Routes = CityWatch::Routes

require 'city_watch/commander/server'
require 'city_watch/commander/home'
