class Accident < ActiveRecord::Base
	geocoded_by :location
	before_save :geocode

	scope :has_coordinates, where('LENGTH(latitude > 0) AND LENGTH(longitude > 0)')	
end
