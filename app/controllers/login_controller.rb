require 'securerandom'

class LoginController < ApplicationController
	def new
	end

	def create
		student_number = params[:student_number]
		password = params[:password]
		# 데이터 받기
		user = User.find_by student_number: student_number # 유저 검색
		# 비번 해시화
		if user and user.password == password # 유저가 있고 비번이 맞으면
			user.token = SecureRandom.hex # 토큰 생성
			render json: { result: 'success', id: user.id, token: user.token } # 정보 반환
		else
			render json: { result: 'fail' } # 정보 반환
		end
	end
end
