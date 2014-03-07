require_relative '../model/init'
require_relative 'requests'
require 'active_support/all'

class DBHelpers
  def initialize(args)
    
  end
  
  def self.insert_travel_time_data(data)
    JourneyTime.delete_all

      data.each do |record|
      
      JourneyTime.create(
          id: record['id'],
          timestamp: record['timestamp_readable'].to_datetime,
          recorded_timestamp: record['recordedtime'].to_datetime,
          estimated_time: record['value'],
          ideal_time: record['idealtime'],
          historic_time: record['historictime'],
          point: "POINT(#{record['lng']} #{record['lat']})",
          from_point: "POINT(#{record['lngfrom']} #{record['latfrom']})",
          to_point: "POINT(#{record['lngto']} #{record['latto']})",
          name: record['locationname'],
          direction: record['direction']
        )
    end

  end

  def self.insert_roadwork_data
    Roadwork.delete_all

    data = Requests.get_current_roadwork_data

    data.each do |record|
      roadwork = Roadwork.new

      roadwork.id = record['id']
      roadwork.timestamp = record['timestamp_readable'].to_datetime
      roadwork.start_time = (if record['starttime'] then record['starttime'].to_datetime end)
      roadwork.end_time = (if record['endtime'] then record['endtime'].to_datetime end)
      roadwork.recorded_time = record['recordedtime']
      roadwork.direction = record['direction']
      roadwork.point = "POINT(#{record['lng']} #{record['lat']})"
      roadwork.line = "LINESTRING(#{record['lngfrom']} #{record['latfrom']}, #{record['lngto']} #{record['latto']})"
      roadwork.delay_time = record['delaytime']
      roadwork.road_maintenance_type = record['roadMaintenanceType']
      roadwork.restricted_lanes = record['restrictedlanes']
      roadwork.subject_type_of_works = record['subjectTypeOfWorks']
      roadwork.operational_lanes = record['value']
      roadwork.occurence_probability = record['occurrence']
      roadwork.comment =  record['comment']
      roadwork.impact = record['impact']
      
      roadwork.save
    end
  end

  def self.get_intersecting_journey_time_records(lat, long, radius)
    bounding_box_coords = GeoHelpers.get_bounding_coords(lat, long, radius)

    JourneyTime.find_by_sql("SELECT * FROM `journey_times` WHERE MBRIntersects(GeomFromText('POLYGON((#{bounding_box_coords[:top_right][1]} #{bounding_box_coords[:top_right][0]}, #{bounding_box_coords[:top_left][1]} #{bounding_box_coords[:top_left][0]}, #{bounding_box_coords[:bottom_left][1]} #{bounding_box_coords[:bottom_left][0]}, #{bounding_box_coords[:bottom_right][1]} #{bounding_box_coords[:bottom_right][0]}, #{bounding_box_coords[:top_right][1]} #{bounding_box_coords[:top_right][0]}))'),
      LINESTRING(to_point, from_point)) and id in (select max(id) from journey_times group by from_point, to_point);")
  end

  def self.get_contained_roadwork_data(lat, long ,radius)
    bounding_box_coords = GeoHelpers.get_bounding_coords(lat, long, radius)

    Roadwork.find_by_sql("SELECT * FROM `roadworks` WHERE MBRContains(GeomFromText('POLYGON((#{bounding_box_coords[:top_right][1]} #{bounding_box_coords[:top_right][0]}, #{bounding_box_coords[:top_left][1]} #{bounding_box_coords[:top_left][0]}, #{bounding_box_coords[:bottom_left][1]} #{bounding_box_coords[:bottom_left][0]}, #{bounding_box_coords[:bottom_right][1]} #{bounding_box_coords[:bottom_right][0]}, #{bounding_box_coords[:top_right][1]} #{bounding_box_coords[:top_right][0]}))'),
      point) and start_time <= now() and end_time >= now() and point is not null;")
  end
end

