require 'mathn'
 
class GeoHelpers
  def initialize(args)
    
  end

  def self.get_bounding_coords lat, lon, distance
    distance = distance.to_f
  
    {
      :top    => calculate_coords(lat, lon, 45, distance),
      :right  => calculate_coords(lat, lon, 135, distance),
      :bottom => calculate_coords(lat, lon, 225, distance),
      :left   => calculate_coords(lat, lon, 315, distance),
    }
  end
   
  def self.calculate_coords lat, lon, bearing, distance
    r_lat = Math.to_rad(lat.to_f)
    r_lon = Math.to_rad(lon.to_f)
    r_brearing = Math.to_rad(bearing.to_f)
    
    max_lat_rads = Math.asin(Math.sin(r_lat) * Math.cos(distance / 6371) + Math.cos(r_lat) * Math.sin(distance / 6371) * Math.cos(r_brearing)) 
    max_lon_rads = r_lon + Math.atan2((Math.sin(r_brearing) * Math.sin(distance / 6371) * Math.cos(r_lat)), (Math.cos(distance / 6371) - Math.sin(r_lat) * Math.sin(max_lat_rads)));
    
    [Math.to_degree(max_lat_rads), Math.to_degree(max_lon_rads)]
  end

class Math
  def initialize(args)
    
  end

  def to_rad degree
    degree * Math::PI / 180
  end
    
  def to_degree radian
    radian * 180/Math::PI
  end
end
end
  