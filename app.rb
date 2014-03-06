require 'sinatra/base'
require_relative 'lib/helpers'
require_relative 'routes/init'

class WonderApp < Sinatra::Base
  helpers Helpers
  set :root, File.dirname(__FILE__)

end 
