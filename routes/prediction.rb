class WonderApp < Sinatra::Base

  get '/prediction.json' do
    content_type :json

    lat  = params['lat']
    long = params['long']
    rad  = params['radius']

    tr = traffic_reports_impact(54.046575001475865, -2.800739901722409, 10)
    rw = road_works_impact(54.046575001475865, -2.800739901722409, 10)
    we = weather_impact(54.046575001475865, -2.800739901722409)

    prediction = ((tr * 0.5) + (rw * 0.3) + (we * 0.2)).to_f / 3

    json = {
      'prediction' => prediction,
      'description' => form_prediction_desc(prediction)
    }.to_json
  end

end