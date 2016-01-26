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
    user = User.find_by student_id: params[:student_id]
    render json: {
      result: (user.check_token token),
    }
  end

  def create
    begin
      user = User.new
      user.student_id = params[:student_id]
      user.set_password params[:password]
      user.save
      render json: {
        'result': true,
      }
    rescue ActiveModel::StrictValidationFailed => e
      render json: {
        'result': false,
        'message': e.message,
      }
    end
  end

  def show
    token = request.headers['HTTP_X_USER_TOKEN']
    user = User.includes(:lectures, :watchings).find_by student_id: params[:student_id]
    lectures = []
    watching_list = []
    if user and user.check_token token
      lectures = user.lectures.as_json(except: [:created_at, :updated_at], methods: [:competitors_number])
      watching_list = Watching.where(user_id: user.id, watch: true).as_json(only: :lecture_id)
    end
    render json: {
      lectures: lectures,
      watching_list: watching_list
    }
  end

  def register
    token = request.headers['HTTP_X_USER_TOKEN']
    user = User.includes(:lectures).find_by student_id: params[:student_id]
    if user and user.check_token token
      lecture = Lecture.find params[:lecture_id]
      user.lectures << lecture
      render json: {
        result: true,
      }
    else
      render json: {
        result: false,
      }
    end
  end

  def unregister
    token = request.headers['HTTP_X_USER_TOKEN']
    user = User.includes(:lectures).find_by student_id: params[:student_id]
    if user and user.check_token token
      lecture = Lecture.find params[:lecture_id]
      user.lectures.delete lecture
      render json: {
        result: true,
      }
    else
      render json: {
        result: false,
      }
    end
  end

  def watch
    token = request.headers['HTTP_X_USER_TOKEN']
    user = User.includes(:lectures).find_by student_id: params[:student_id]
    if user and user.check_token token
      Watching.find_by(user_id: user.id, lecture_id: params[:lecture_id]).update(watch: true)
      render json: {
        result: true,
      }
    else
      render json: {
        result: false,
      }
    end
  end

  def unwatch
    token = request.headers['HTTP_X_USER_TOKEN']
    user = User.includes(:lectures).find_by student_id: params[:student_id]
    if user and user.check_token token
      Watching.find_by(user_id: user.id, lecture_id: params[:lecture_id]).update(watch: false)
      render json: {
        result: true,
      }
    else
      render json: {
        result: false,
      }
    end
  end
end
