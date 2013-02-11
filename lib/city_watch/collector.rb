require 'rack/mount'

module CityWatch
  Routes = Rack::Mount::RouteSet.new
end

::Routes = CityWatch::Routes

require 'city_watch/util/collector'
require 'city_watch/watchmen'
require 'city_watch/collector/receive'