require 'rails_helper'

RSpec.describe Post, type: :model do
  it { is_expected.to be }

  it 'can be created with custom time' do
    Post.create(message: 'This is a test post', created_at: '2019-01-01 12:12:12')
    expect(Post.first.message).to eq('This is a test post')
    puts Post.first.created_at
    puts Post.first.updated_at
  end

  it 'doesn\'t persist records across tests' do
    puts Post.all
    expect(Post.first).to eq(nil)
    puts Post.first
  end
end
