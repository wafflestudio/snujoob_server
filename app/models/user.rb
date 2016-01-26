require 'digest'
require 'securerandom'

class User < ActiveRecord::Base
  has_many :watchings
  has_many :lectures, through: :watchings

  validates :student_id, presence: true, uniqueness: true, format: { with: /\A20[0-9]{2}-[12][0-9]{4}\z/ }
  validates :password, presence: true
  validates :salt, presence: true

  def set_password(password)
    self.salt = SecureRandom.hex
    self.password = Digest::SHA256.hexdigest(password + self.salt)
  end

  def check_password(password)
    self.password == Digest::SHA256.hexdigest(password + self.salt)
  end
end
