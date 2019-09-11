class User < ApplicationRecord
  include Clearance::User
  # has_secure_password
  has_many :posts, dependent: :destroy
end
