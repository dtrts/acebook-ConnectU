class Post < ApplicationRecord
    belongs_to :user
    has_many :comments, dependent: :destroy


    def get_time
        self.created_at.strftime("%I:%M %p, %d of %B")
    end

end
