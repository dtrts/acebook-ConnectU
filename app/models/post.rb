# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  
  has_many :comments

  def get_time
    created_at.strftime('%I:%M %p, %d of %B')
  end
end
