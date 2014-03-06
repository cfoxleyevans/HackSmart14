require_relative '../model/init'
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
end


