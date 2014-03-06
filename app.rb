require 'sinatra/base'
require_relative 'model/init'
require_relative 'lib/helpers'
<<<<<<< HEAD
require_relative 'lib/requests'
=======
require_relative 'lib/db_helpers'
require_relative 'lib/geo_helpers'
>>>>>>> FETCH_HEAD
require_relative 'routes/init'


class WonderApp < Sinatra::Base
  helpers Helpers
  set :root, File.dirname(__FILE__)

  after do
    ActiveRecord::Base.connection.close
  end
end 
