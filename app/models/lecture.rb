require 'gcm'

class Lecture < ActiveRecord::Base
  has_many :watchings
  has_many :users, through: :watchings

  after_save :validate_push

  validates :subject_number, :lecture_number, presence: true

  def competitors_number
    Watching.where(lecture_id: self.id).count
  end

  def validate_push
    snujoob = YAML::load_file("config/snujoob.yml")||[]
    third_day = DateTime.strptime(snujoob["third_day"], '%Y-%m-%d %z')
    free_day = DateTime.strptime(snujoob["free_day"], '%Y-%m-%d %z')
    now = Time.now

    if (1.days.ago third_day) < now and now <= (third_day + 3.days)
      # 변경 가능 (재학생만)
      if 9 != now.hour
      # 부하시간이 아니고
        if enrolled < enrolled_capacity
          push
        end
      end
    elsif (1.days.ago free_day) < now and now < (free_day + 1.weeks)
      # 변경 가능 (모두)
      if 9 != now.hour
      # 부하시간이 아니고
        if enrolled < whole_capacity
          push
        end
      end
    end
  end

  private
  def push
    api_key = YAML::load_file(Rails.root.to_s + '/config/gcm_api_key.yml')['gcm_api_key']
    gcm = GCM.new(api_key)
    options = {
      data: {
        title: "#{name} 이 비었습니다",
        message: "#{name} (#{lecture_number} #{lecturer}) 가 비었습니다\n#{time}\n알림받은 사람 #{competitors_number}명\n\n알림을 누르면 수강신청 사이트로 이동합니다",
        lecture_id: id
      }
    }

    reg_ids = Array.new
    Watching.includes(:user).where(lecture_id: id, watch: true).each do |w|
      reg_ids << w.user.gcm_token
    end

    response = gcm.send(reg_ids, options)
  end
end
