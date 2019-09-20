class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'room_channel'
    Message.create!(content: 'logged on', user_id: current_user.id)
  end

  def unsubscribed
    Message.create!(content: 'logged off', user_id: current_user.id)
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    # ActionCable.server.broadcast "room_channel", message: data['message']
    Message.create!(content: data['message'], user_id: current_user.id)
  end
end
