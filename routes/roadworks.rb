require 'json'

class WonderApp < Sinatra::Base
  get '/roadworks/all.json' do
    content_type :json

    result = Roadwork.where("start_time <= now() and end_time >= now() and point is not null").limit(500).map do |record|
      {
        :type => 'Point',
        :coordinates => [record.point.x, record.point.y],
        :properties => {
          :comment => record.comment
        }
      }
    end

    result.to_json
  end

  get '/roadworks' do
    erb :roadworks
  end
end