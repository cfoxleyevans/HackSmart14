require "json"

require_relative "../model/init"
require_relative "requests"
require_relative "db_helpers"
require_relative "geo_helpers"

# Any tests for data routes can go here
Requests.get_venues_of_type_in_range("54.0056373,-2.7849923", 500, "coffee")

DBHelpers.insert_travel_time_data(Requests.get_travel_time_data(nil))

results = DBHelpers.get_intersecting_journey_time_records(54.0056373, -2.7849923, 10)

puts "\n"

<<<<<<< HEAD
#DBHelpers.get_intersecting_journey_time_records(54.0056373, -2.7849923, 10)
=======
results.each do |route|
	puts "Route ID:#{route.id}"
>>>>>>> FETCH_HEAD

	ratio = route.ideal_time / route.estimated_time

	if(ratio > 1.1)
		puts " Slow Route"
	end
	if(ratio < 0.9)
		puts " Fast Route"
	end
	if(ratio > 0.9 or route_ratio < 1.1)
		puts " Normal Route"
	end
end

