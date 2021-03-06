require 'active_support/all'
require 'json'

class WonderApp < Sinatra::Base

  get '/music/playlist.json' do
    content_type :json

    parameters = {
        target_tempo: (params['speed'].to_i * 180) + 60,
        target_energy: params['energy'],
        target_danceability: params['danceability']
    }

    url = "http://developer.echonest.com/api/v4/playlist/static?api_key=IOEKRKJN4SQVXE4LO&format=json&results=7&type=genre-radio&genre=pop&genre=rock&genre=electronic&genre=indie+rock&bucket=id:spotify-WW&bucket=tracks&#{parameters.to_query}"

    uri =  URI.parse(url)


    http = Net::HTTP.new(uri.host, uri.port)
    response = http.get(uri.request_uri)

    response.body
  end

  get '/music/playlist' do
    erb :playlist
  end

end