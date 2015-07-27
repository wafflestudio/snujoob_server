class User < ActiveRecord::Base
  has_and_belongs_to_many :subjects
  validates :student_number,
    format: { with: /20[0-9]{2}-[0-9]{5}/, message: "is not student number" },
    uniqueness: true
end
