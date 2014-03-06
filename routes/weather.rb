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
end