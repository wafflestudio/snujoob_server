require 'securerandom'
require 'digest'

class UsersController < ApplicationController
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
end
