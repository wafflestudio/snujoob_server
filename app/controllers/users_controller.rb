require 'securerandom'
require 'digest'

class UsersController < ApplicationController
	skip_before_filter :verify_authenticity_token

	def show
		token = params[:token]
		user = User.find params[:id]
		if user and user.token == token
			subjects = Array.new
			for subject in user.subjects
				subjects << { 'id' => subject.id, 'subject_name' => subject.subject_name }
			end
			render json: { id: user.id, student_number: user.student_number, subjects: subjects }
		else
			render json: { result: 'fail' }
		end
	end

	def create
		user = User.new
		user.student_number = params[:student_number]
		user.password = params[:password]
		user.salt = SecureRandom.hex
		user.password = Digest::SHA2.hexdigest(user.password + user.salt)
		if user.save
			render json: { result: 'success' }
		else
			render json: { result: 'fail' }
		end
	end

	def destroy
		user = User.find params[:id]
		user.destroy
	end

	def register
		token = params[:token]
		user = User.find params[:id]
		if user and user.token == token
			subject = Subject.find params[:subject_id]
			if subject
				user.subjects << subject
			end
		end
	end

	def unregister
		token = params[:token]
		user = User.find params[:id]
		if user and user.token == token
			subject = Subject.find params[:subject_id]
			if subject
				user.subjects.delete(subject)
			end
		end
	end
end
