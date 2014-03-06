require 'net/http'
require 'json'
require 'active_support/all'

class Requests
	def initialize(args)
		
	end
	
	@keys = {
		:ss_api_key => '6c05da93-c769-4781-a5cf-40361a8cecfe',
		:four_square_client_id => 'TRUJCAKIPN4RK5GO4YROIJMROVLODGY4KQ4RH4LHNVOQGZP2',
		:four_square_client_secret => 'ST3EJU0LDX4CEUXX2VP1R4O3REDMUPA1OQLYA32SOAA4NICI'
 	}

	# Smart Streets API Routes
	def get_trafic_data(number_of_records)
		keys = {'x-api-key' => @keys[:ss_api_key]}
		uri = URI.parse("http://smartstreets.sensetecnic.com/wotkit/api/sensors/42607/data?beforeE=#{number_of_records}")
		http = Net::HTTP.new(uri.host, uri.port)
		response = http.get(uri.request_uri, keys)
		json = parse_api_response(response.body)
	end

	def get_matrix_sign_data(number_of_records)
		keys = {'x-api-key' => @keys[:ss_api_key]}
		uri = URI.parse("http://smartstreets.sensetecnic.com/wotkit/api/sensors/42606/data?beforeE=#{number_of_records}")
		http = Net::HTTP.new(uri.host, uri.port)
		response = http.get(uri.request_uri, keys)
		json = parse_api_response(response.body)
	end	

	def get_variable_message_sign_data(number_of_records)
		keys = {'x-api-key' => @keys[:ss_api_key]}
		uri = URI.parse("http://smartstreets.sensetecnic.com/wotkit/api/sensors/42605/data?beforeE=#{number_of_records}")
		http = Net::HTTP.new(uri.host, uri.port)
		response = http.get(uri.request_uri, keys)
		json = parse_api_response(response.body)
	end

	def get_future_roadwork_data(number_of_records)
		keys = {'x-api-key' => @keys[:ss_api_key]}
		uri = URI.parse("http://smartstreets.sensetecnic.com/wotkit/api/sensors/42603/data?beforeE=#{number_of_records}")
		http = Net::HTTP.new(uri.host, uri.port)
		response = http.get(uri.request_uri, keys)
		json = parse_api_response(response.body)
	end

	def get_current_roadwork_data(number_of_records)
		keys = {'x-api-key' => @keys[:ss_api_key]}
		uri = URI.parse("http://smartstreets.sensetecnic.com/wotkit/api/sensors/42602/data?beforeE=#{number_of_records}")
		http = Net::HTTP.new(uri.host, uri.port)
		response = http.get(uri.request_uri, keys)
		json = parse_api_response(response.body)
	end

	def get_unplanned_events_data(number_of_records)
		keys = {'x-api-key' => @keys[:ss_api_key]}
		uri = URI.parse("http://smartstreets.sensetecnic.com/wotkit/api/sensors/42601/data?beforeE=#{number_of_records}")
		http = Net::HTTP.new(uri.host, uri.port)
		response = http.get(uri.request_uri, keys)
		json = parse_api_response(response.body)
	end

	def get_future_planned_events(number_of_records)
		keys = {'x-api-key' => @keys[:ss_api_key]}
		uri = URI.parse("http://smartstreets.sensetecnic.com/wotkit/api/sensors/42600/data?beforeE=#{number_of_records}")
		http = Net::HTTP.new(uri.host, uri.port)
		response = http.get(uri.request_uri, keys)
		json = parse_api_response(response.body)
	end

	def get_planned_events_data(number_of_records)
		keys = {'x-api-key' => @keys[:ss_api_key]}
		uri = URI.parse("http://smartstreets.sensetecnic.com/wotkit/api/sensors/42599/data?beforeE=#{number_of_records}")
		http = Net::HTTP.new(uri.host, uri.port)
		response = http.get(uri.request_uri, keys)
		json = parse_api_response(response.body)
	end

	def self.get_travel_time_data(number_of_records)
		keys = {'x-api-key' => @keys[:ss_api_key]}
		uri = URI.parse("http://smartstreets.sensetecnic.com/wotkit/api/sensors/42598/data?beforeE=#{number_of_records}")
		http = Net::HTTP.new(uri.host, uri.port)
		response = http.get(uri.request_uri, keys)
		json = parse_api_response(response.body)
	end

	# 4Square API Routes
	def self.get_venues_of_type_in_range(lat, long, parameters={})
		uri = URI.parse(
			"https://api.foursquare.com/v2/venues/explore?ll=#{lat},#{long}&" +
			"client_id=#{@keys[:four_square_client_id]}&client_secret=#{@keys[:four_square_client_secret]}&v=20140301&" +
			"#{parameters.to_query}"
			)

		p uri

		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		response = http.get(uri.request_uri)

		json = parse_api_response(response.body)
	end

	private
	def self.parse_api_response(json)
		data = JSON.parse(json)

		p data
	end	
	
end


