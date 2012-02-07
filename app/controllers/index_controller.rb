class IndexController < ApplicationController
	def index
        @content = "This is Andy's baller app"
		@accident = Accident.all
	end
end
