class Post < ApplicationRecord
  belongs_to :user

  def get_time
    created_at.strftime('%I:%M %p, %d of %B')
  end
end
