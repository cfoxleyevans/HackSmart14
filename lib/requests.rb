require 'net/http'
require 'json'

class Requests
	def initialize(args)
		
	end
	
	@headers = {
		:x_api_key => '6c05da93-c769-4781-a5cf-40361a8cecfe'
 	}

	def get_trafic_data(number_of_records)
		headers = {'x-api-key' => @headers[:x_api_key]}
		uri = URI.parse("http://smartstreets.sensetecnic.com/wotkit/api/sensors/42607/data?beforeE=#{number_of_records}")
		http = Net::HTTP.new(uri.host, uri.port)
		response = http.get(uri.request_uri, headers)
		json = parse_api_response(response)
	end

	def get_matrix_sign_data(number_of_records)
		headers = {'x-api-key' => @headers[:x_api_key]}
		uri = URI.parse("http://smartstreets.sensetecnic.com/wotkit/api/sensors/42606/data?beforeE=#{number_of_records}")
		http = Net::HTTP.new(uri.host, uri.port)
		response = http.get(uri.request_uri, headers)
		json = parse_api_response(response)
	end	

	def get_variable_message_sign_data(number_of_records)
		headers = {'x-api-key' => @headers[:x_api_key]}
		uri = URI.parse("http://smartstreets.sensetecnic.com/wotkit/api/sensors/42605/data?beforeE=#{number_of_records}")
		http = Net::HTTP.new(uri.host, uri.port)
		response = http.get(uri.request_uri, headers)
		json = parse_api_response(response)
	end

	def get_future_roadwork_data(number_of_records)
		headers = {'x-api-key' => @headers[:x_api_key]}
		uri = URI.parse("http://smartstreets.sensetecnic.com/wotkit/api/sensors/42603/data?beforeE=#{number_of_records}")
		http = Net::HTTP.new(uri.host, uri.port)
		response = http.get(uri.request_uri, headers)
		json = parse_api_response(response)
	end

	def get_current_roadwork_data(number_of_records)
		headers = {'x-api-key' => @headers[:x_api_key]}
		uri = URI.parse("http://smartstreets.sensetecnic.com/wotkit/api/sensors/42602/data?beforeE=#{number_of_records}")
		http = Net::HTTP.new(uri.host, uri.port)
		response = http.get(uri.request_uri, headers)
		json = parse_api_response(response)
	end

	def get_unplanned_events_data(number_of_records)
		headers = {'x-api-key' => @headers[:x_api_key]}
		uri = URI.parse("http://smartstreets.sensetecnic.com/wotkit/api/sensors/42601/data?beforeE=#{number_of_records}")
		http = Net::HTTP.new(uri.host, uri.port)
		response = http.get(uri.request_uri, headers)
		json = parse_api_response(response)
	end

	def get_future_planned_events(number_of_records)
		headers = {'x-api-key' => @headers[:x_api_key]}
		uri = URI.parse("http://smartstreets.sensetecnic.com/wotkit/api/sensors/42600/data?beforeE=#{number_of_records}")
		http = Net::HTTP.new(uri.host, uri.port)
		response = http.get(uri.request_uri, headers)
		json = parse_api_response(response)
	end

	def get_planned_events_data(number_of_records)
		headers = {'x-api-key' => @headers[:x_api_key]}
		uri = URI.parse("http://smartstreets.sensetecnic.com/wotkit/api/sensors/42599/data?beforeE=#{number_of_records}")
		http = Net::HTTP.new(uri.host, uri.port)
		response = http.get(uri.request_uri, headers)
		json = parse_api_response(response)
	end

	def self.get_travel_time_data(number_of_records)
		headers = {'x-api-key' => @headers[:x_api_key]}
		uri = URI.parse("http://smartstreets.sensetecnic.com/wotkit/api/sensors/42598/data?beforeE=#{number_of_records}")
		http = Net::HTTP.new(uri.host, uri.port)
		response = http.get(uri.request_uri, headers)
		json = parse_api_response(response)
	end

	private

	def self.parse_api_response(json)
		data = JSON.parse(json)
	end	
	
end


