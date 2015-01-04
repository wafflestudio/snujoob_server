class SubjectsController < ApplicationController
	def index
		@subjects = Subject.all
		respond_to do |format|
			format.html
			format.json { render json: { subjects: @subjects } }
		end
	end
end
