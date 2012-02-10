class IndexController < ApplicationController
	def index
		@accident_count = Accident.count
		@accident = Accident.coordinates_available
	end
end
