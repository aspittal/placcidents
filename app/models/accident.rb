class Accident < ActiveRecord::Base
	geocoded_by :location
	before_save :geocode

	scope :has_coordinates, where('latitude IS NOT NULL AND longitude IS NOT NULL')	
end
