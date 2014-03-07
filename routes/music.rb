require 'active_support/all'
require 'json'

class WonderApp < Sinatra::Base
  get '/mmmmusic' do
  content_type :json

  parameters = {
      max_liveness: 0.05
  }

  uri =  URI.parse("http://developer.echonest.com/api/v4/playlist/static?api_key=IOEKRKJN4SQVXE4LO&format=json&results=20&type=genre-radio&genre=pop&genre=rock&genre=electronic&genre=indie rock&bucket=id:spotify-WW&bucket=tracks&#{parameters.to_query}")

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  response = http.get(uri.request_uri)

  response.body
end
end