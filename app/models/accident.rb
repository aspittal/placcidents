class Accident < ActiveRecord::Base
	geocoded_by :location
	after_validation :geocode

	scope :most_fatal, order("fatalities DESC").limit(100)
	scope :coordinates_available, order('longitude DESC').limit(100)
end
