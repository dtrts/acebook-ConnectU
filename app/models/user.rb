class User < ApplicationRecord
  include Clearance::User

  has_many :posts, dependent: :destroy

#   def gravatar_url
#   gravatar_id = Digest::MD5::hexdigest(email).downcase
#   "https://gravatar.com/avatar/#{gravatar_id}.png"
# end

  # has_secure_password
end
