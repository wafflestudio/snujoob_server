class User < ActiveRecord::Base
  has_many :watchings
  has_many :lectures, through: :watchings
end
