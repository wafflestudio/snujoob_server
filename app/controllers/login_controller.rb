require 'securerandom'
require 'digest'

class LoginController < ApplicationController
	skip_before_filter :verify_authenticity_token

	def new
	end

	def create
		student_number = params[:student_number]
		password = params[:password]
		# 데이터 받기
		user = User.find_by student_number: student_number # 유저 검색
		if user and user.password == Digest::SHA2.hexdigest(password + user.salt) # 유저가 있고 비번이 맞으면
			user.token = SecureRandom.hex # 토큰 생성
			user.reg_id = params[:reg_id]
			user.device = params[:device]
			user.save
			render json: { result: 'success', id: user.id, token: user.token } # 정보 반환
		else
			render json: { result: 'fail' } # 정보 반환
		end
	end
end
