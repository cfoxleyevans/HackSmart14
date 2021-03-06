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

  get '/journey_times/nerarby_routes' do
    content_type :json

    lat = params[:lat]
    long = params[:long]
    radius = params[:radius]

    

    results = DBHelpers.get_intersecting_journey_time_records(lat, long, radius).map do |record|
      ratio = record.ideal_time / record.estimated_time

      if(ratio > 1.2)
        severity = "severe"
      end
      
      if(ratio > 1.1 and ratio <= 1.2)
        severity = "moderate"
      end
      
      if(ratio > 0.9 and ratio <= 1.1)
        severity = "normal"
      end

      if (ratio <= 0.9)
        severity = "clear"
      end 

      {
        :timestamp => record.recorded_timestamp,
        
        :coordinates =>  {
          :from => [record.from_point.y, record.from_point.x], 
          :to => [record.to_point.y, record.to_point.x]
        },
        
        :difference => record.ideal_time - record.estimated_time,
        :severity => severity,
        :ratio => ratio.to_f,
        :description => Helpers.shorten_description(record.name)
      }
      end
    results.to_json
  end
end





