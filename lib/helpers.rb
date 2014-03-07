module Helpers

	def self.shorten_description(string)
		string[25..string.length] if string[0..24] === 'Journey Time Section for '
	end

  # Helper Methods for Prediction Route

  def number_of_road_works lat, long, radius
    bounding_box_coords = GeoHelpers.get_bounding_coords(lat, long, radius)

    Roadwork.find_by_sql("SELECT * FROM `roadworks` WHERE MBRContains(GeomFromText('POLYGON((#{bounding_box_coords[:top_right][1]} #{bounding_box_coords[:top_right][0]}, #{bounding_box_coords[:top_left][1]} #{bounding_box_coords[:top_left][0]}, #{bounding_box_coords[:bottom_left][1]} #{bounding_box_coords[:bottom_left][0]}, #{bounding_box_coords[:bottom_right][1]} #{bounding_box_coords[:bottom_right][0]}, #{bounding_box_coords[:top_right][1]} #{bounding_box_coords[:top_right][0]}))'),
      POINT(point)) and id in (select max(id) from roadworks group by point);")

  def prediction_traffic_reports lat, long, radius
    bounding_box_coords = GeoHelpers.get_bounding_coords(lat, long, radius)

    reports = JourneyTime.find_by_sql("SELECT * FROM `journey_times` WHERE MBRIntersects(GeomFromText('POLYGON((#{bounding_box_coords[:top_right][1]} #{bounding_box_coords[:top_right][0]}, #{bounding_box_coords[:top_left][1]} #{bounding_box_coords[:top_left][0]}, #{bounding_box_coords[:bottom_left][1]} #{bounding_box_coords[:bottom_left][0]}, #{bounding_box_coords[:bottom_right][1]} #{bounding_box_coords[:bottom_right][0]}, #{bounding_box_coords[:top_right][1]} #{bounding_box_coords[:top_right][0]}))'),
      LINESTRING(to_point, from_point)) and id in (select max(id) from journey_times group by from_point, to_point);")

    ratio_sum = 0
    reports.each do |report|
      ratio_sum += report.ideal_time.to_f / report.estimated_time.to_f
    end

    {
      :total     => reports.length,
      :ratio_avg => ratio_sum.to_f / reports.length
    }
  end

  def get_weather lat, long

  end

end
