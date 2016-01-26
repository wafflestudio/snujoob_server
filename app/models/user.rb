require 'digest'
require 'securerandom'

class User < ActiveRecord::Base
  has_many :watchings
  has_many :lectures, through: :watchings

  validates! :student_id, presence: true, uniqueness: true, format: { with: /\A20[0-9]{2}-[12][0-9]{4}\z/ }
  validates :password, presence: true
  validates :salt, presence: true

  def set_password(password)
    self.salt = SecureRandom.hex
    self.password = Digest::SHA256.hexdigest(password + self.salt)
  end

  def check_password(password)
    self.password == Digest::SHA256.hexdigest(password + self.salt)
  end

  def update_gcm_token(gcm_token)
    self.gcm_token = gcm_token
  end

  def generate_token
    self.login_token = SecureRandom.hex
  end

  def check_token(token)
    self.login_token == token
  end
end
