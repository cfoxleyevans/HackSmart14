class WonderApp < Sinatra::Base

  get '/prediction.json' do
    content_type :json

    lat  = params['lat']
    long = params['long']
    rad  = params['radius']

    json = {
      'dummy' => prediction_traffic_reports(54.046575001475865, -2.800739901722409, 10),
      'rw' => number_of_road_works(54.046575001475865, -2.800739901722409, 10)
    };

    json.to_json
  end

end