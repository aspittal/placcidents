class IndexController < ApplicationController
	def index
		@accident_count = Accident.coordinates_available.count
		@accident = Accident.coordinates_available.all
	end
end
