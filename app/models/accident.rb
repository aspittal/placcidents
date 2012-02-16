class Accident < ActiveRecord::Base
	geocoded_by :location
	before_save :geocode

	scope :has_coordinates, where('LENGTH(latitude > 0) AND LENGTH(longitude > 0)')	
	scope :most_fatal, order('fatalities DESC, ground_fatalities DESC')
	scope :most_ground_fatalities, order('ground_fatalities DESC')
end
