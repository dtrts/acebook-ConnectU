require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'creates and deletes' do
    it 'signed in user creates a new comment' do
      user = sign_in
      post = FactoryBot.create(:post, user_id: user.id)
      post(:create, params: { post_id: post.id, comment: { body: 'I am a comment' } })
      expect(Comment.find_by(body: 'I am a comment')).to be
    end

    it ' signed in user deleting own comment' do
      user = sign_in
      post = FactoryBot.create(:post, user_id: user.id)
      comment = FactoryBot.create(:comment, user_id: user.id, post_id: post.id)
      delete(:destroy, params: { id: comment.id })
      expect(Comment.find_by(id: comment.id)).not_to be
      # expect(Comment.find_by(id: comment.id)).to be
    end

    it 'user cannot delete another users comment' do
      user = FactoryBot.create(:user)
      post = FactoryBot.create(:post, user_id: user.id)
      comment = FactoryBot.create(:comment, user_id: user.id, post_id: post.id)
      user2 = sign_in
      delete(:destroy, params: { id: comment.id })
      expect(Comment.find_by(id: comment.id)).to be
    end
  end
end
