class Lecture < ActiveRecord::Base
  has_many :watchings
  has_many :users, through: :watchings

  validates :subject_number, :lecture_number, presence: true

  def competitors_number
    Watching.where(lecture_id: self.id).count
  end
end
