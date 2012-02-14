class Accident < ActiveRecord::Base
	geocoded_by :location
	before_save :geocode

	scope :most_fatal, order("fatalities DESC").limit(100)
	scope :coordinates_available, where('LENGTH(longitude) > 0')
end
