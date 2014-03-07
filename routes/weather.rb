require 'net/http'
require 'json'

class WonderApp < Sinatra::Base
	get '/weather.json' do
		content_type :json
		
		uri =  URI.parse("https://api.forecast.io/forecast/89e98468f9817b18cd7f337bd4256982/#{params['lat']},#{params['long']}?units=uk")

		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		response = http.get(uri.request_uri)

		response.body
	end

	get '/weather/nearby_weather' do
		content_type :json
		
		uri =  URI.parse("https://api.forecast.io/forecast/89e98468f9817b18cd7f337bd4256982/#{params['lat']},#{params['long']}?units=uk")

		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		response = http.get(uri.request_uri)

		data = JSON.parse(response.body)

  	response = {
    	:current_summary => data['currently']['summary'],
    	:current_temp => data['currently']['temperature'],
    	:currently_feels_like => data['currently']['apparentTemperature'],
    	:curent_icon => data['currently']['icon'],
    	:next_summary => data['hourly']['data'][1]['summary'],
    	:next_temp => data['hourly']['data'][1]['temperature']
    }
    response.to_json
	end
end