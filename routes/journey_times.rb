require 'json'

class WonderApp < Sinatra::Base
  get '/journey_times' do
    erb :journey_times
  end

  get '/journey_times.json' do
  	content_type :json
  	
  	results = JourneyTime.find_by_sql('select * from journey_times where id in (select max(id) from journey_times group by from_point, to_point)').map do |record|
  		{
			:type => 'LineString',
	        :coordinates => [[record.to_point.x, record.to_point.y], [record.from_point.x, record.from_point.y]],
	        :properties => {
	        	:name => record.name,
                :estimated_time => record.estimated_time,
                :ideal_time => record.ideal_time
            }
		}
  	end

  	results.to_json
  end
end
