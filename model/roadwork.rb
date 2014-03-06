class Roadwork < ActiveRecord::Base
	self.rgeo_factory_generator = RGeo::Geos.method(:factory)
end