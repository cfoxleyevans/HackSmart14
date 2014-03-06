require_relative "../model/init"
require_relative "requests"
require_relative "db_helpers"


DBHelpers.insert_travel_time_data(Requests.get_travel_time_data(150))



