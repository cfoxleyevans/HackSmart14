require './app'

run Rack::URLMap.new '/' => WonderApp
