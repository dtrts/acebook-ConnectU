require 'rails_helper'

RSpec.describe Post, type: :model do
  it { is_expected.to be }

  it 'can be created with custom time' do
    # needs a user id
    user = FactoryBot.create(:user, password: 'password')
    Post.create(message: 'This is a test post', created_at: '2019-01-01 12:12:12', user_id: user.id)
    expect(Post.first.message).to eq('This is a test post')
    expect(Post.first.created_at).to eq('2019-01-01 12:12:12')
  end

  it 'doesn\'t persist records across tests' do
    expect(Post.first).to eq(nil)
  end
end
