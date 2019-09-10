require 'rails_helper'
# require_relative '../../app/models/user'

describe User do
  it 'destroys dependent posts' do
    user = FactoryBot.create(:user, password: 'password')
    post = FactoryBot.create(:post, user_id: user.id)
    user.destroy
    expect(Post.all.count).to eq(0)
  end
end
