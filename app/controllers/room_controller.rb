class RoomController < ApplicationController
  def show
    @messages = Message.order(created_at: :asc).last(25)
  end
end
