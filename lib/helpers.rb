module Helpers

	def self.shorten_description(string)
		string[25..string.length] if string[0..24] === 'Journey Time Section for '
	end

  # Helper Methods for Prediction Route

  def road_works_impact lat, long, radius
    bounding_box_coords = GeoHelpers.get_bounding_coords(lat, long, radius)

    rws = Roadwork.find_by_sql("SELECT * FROM `roadworks` WHERE MBRContains(GeomFromText('POLYGON((#{bounding_box_coords[:top_right][1]} #{bounding_box_coords[:top_right][0]}, #{bounding_box_coords[:top_left][1]} #{bounding_box_coords[:top_left][0]}, #{bounding_box_coords[:bottom_left][1]} #{bounding_box_coords[:bottom_left][0]}, #{bounding_box_coords[:bottom_right][1]} #{bounding_box_coords[:bottom_right][0]}, #{bounding_box_coords[:top_right][1]} #{bounding_box_coords[:top_right][0]}))'),
      point);")

    impact_lookup = {
      'freeFlow' => 0.5,
      'heavy' => 0.75,
      'impossible' => 1
    }

    impact_sum = 0
    rws.each do |rw|
      impact_sum += impact_lookup[rw.impact]
    end

    impact_sum.to_f / rws.length
  end

  def traffic_reports_impact lat, long, radius
    bounding_box_coords = GeoHelpers.get_bounding_coords(lat, long, radius)

    reports = JourneyTime.find_by_sql("SELECT * FROM `journey_times` WHERE MBRIntersects(GeomFromText('POLYGON((#{bounding_box_coords[:top_right][1]} #{bounding_box_coords[:top_right][0]}, #{bounding_box_coords[:top_left][1]} #{bounding_box_coords[:top_left][0]}, #{bounding_box_coords[:bottom_left][1]} #{bounding_box_coords[:bottom_left][0]}, #{bounding_box_coords[:bottom_right][1]} #{bounding_box_coords[:bottom_right][0]}, #{bounding_box_coords[:top_right][1]} #{bounding_box_coords[:top_right][0]}))'),
      LINESTRING(to_point, from_point)) and id in (select max(id) from journey_times group by from_point, to_point);")

    ratio_sum = 0
    reports.each do |report|
      ratio_sum += report.ideal_time.to_f / report.estimated_time.to_f
    end

    ratio_sum.to_f / reports.length
  end

  def weather_impact lat, long
    uri =  URI.parse("https://api.forecast.io/forecast/89e98468f9817b18cd7f337bd4256982/#{lat},#{long}?units=uk")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    response = http.get(uri.request_uri)

    json = JSON.parse(response.body)

    precip_prob = json['currently']['precipProbability']
    precib_int  = json['currently']['precipIntensity']
    wind_speed  = json['currently']['windSpeed'].to_f / 100

    (precip_prob + precib_int + wind_speed).to_f / 3
  end

  def form_prediction_desc n
    return 'Ideal conditions for travelling - enjoy!' if n <= 0.4
    return 'Okay to set off, however expect minor delays' if n > 0.4 and n <= 0.7
    return 'Expect significant delays - why not set off slightly later?' if n > 0.7 and n <= 1
    return 'Major delays! We suggest you stay put for now!' if n > 1
  end

end
