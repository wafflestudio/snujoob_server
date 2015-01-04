class SubjectsController < ApplicationController
	def index
		@subjects = Subject.all
		respond_to do |format|
			format.html
			format.json { render json: { subjects: @subjects } }
		end
	end

	def show
		@subject = Subject.find params[:id]
		respond_to do |format|
			format.html
			format.json { render json: { subject: @subject } }
		end
	end
end
