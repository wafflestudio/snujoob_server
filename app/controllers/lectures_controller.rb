class LecturesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def search
    query = params[:query].to_s
    real_query = '%'
    query.split(//u).each {|c| real_query << (c + '%')}
    lectures = []
    if query != ''
      lectures = Lecture.where('name LIKE ?', real_query).as_json(except: [:created_at, :updated_at], methods: [:competitors_number])
    end
    render json: {
      lectures: lectures
    }
  end
end
