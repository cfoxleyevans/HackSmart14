require 'json'

class WonderApp < Sinatra::Base

  get '/foursquare.json' do
    content_type :json

    json = Requests.get_venues_of_type_in_range(params['lat'], params['long'], radius: 1500)

    json.to_json
  end

end