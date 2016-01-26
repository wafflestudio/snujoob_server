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

  def auto_login
    token = request.headers['HTTP_X_USER_TOKEN']
    puts token
    user = User.find_by student_id: params[:student_id]
    render json: {
      result: (user.check_token token),
    }
  end
end
