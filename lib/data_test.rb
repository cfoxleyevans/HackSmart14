require_relative "../model/init"
require_relative "requests"
require_relative "db_helpers"

# Any tests for data routes can go here
# Requests.get_venues_of_type_in_range("54.0056373,-2.7849923", 500, "coffee")

DBHelpers.insert_travel_time_data(Requests.get_travel_time_data(150))



