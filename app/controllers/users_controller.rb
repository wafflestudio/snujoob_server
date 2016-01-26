class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def login
    user = User.find_by student_id: params[:student_id]
    if user and user.check_password params[:password]
      user.generate_token
      user.save
      render json: {
        'result': true,
        'token': user.login_token,
      }
    else
      render json: {
        'result': false,
      }
    end
  end
end
