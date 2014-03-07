class WonderApp < Sinatra::Base

  get '/prediction.json' do
    content_type :json

    lat  = params['lat']
    long = params['long']

    json = {
      'dummy' => 'text'
    };

    json.to_json
  end

end