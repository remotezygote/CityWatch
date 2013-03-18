require 'rack/mount'

module CityWatch
  Routes = Rack::Mount::RouteSet.new
end

::Routes = CityWatch::Routes

require 'city_watch/util/renderer'
require 'city_watch/watchmen'
require 'city_watch/reader'
require 'city_watch/commander/server'
require 'city_watch/commander/home'
