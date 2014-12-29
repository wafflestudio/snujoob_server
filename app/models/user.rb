class User < ActiveRecord::Base
	validates :student_number,
		format: { with: /20[0-9]{2}-[0-9]{5}/, message: "is not student number" },
		uniqueness: true
end
