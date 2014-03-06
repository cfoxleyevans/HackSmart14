require 'sinatra/base'
require_relative 'model/init'
require_relative 'lib/helpers'
require_relative 'routes/init'

class WonderApp < Sinatra::Base
  helpers Helpers
  set :root, File.dirname(__FILE__)

  after do
    ActiveRecord::Base.connection.close
  end
end 
