require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe 'GET /posts main feed' do
    it 'responds with 200' do
      sign_in
      get :index
      expect(response).to have_http_status(200)
    end
  end

  describe 'creating posts' do
    it '/posts/new responds with 200' do
      sign_in
      get(:new)
      expect(response).to have_http_status(200)
    end

    it 'redirects to post page' do
      sign_in
      post :create, params: { post: { message: 'Hello, world!' } }
      expect(response).to redirect_to(posts_url)
    end

    it 'creates a post' do
      user = sign_in
      post :create, params: { post: { message: 'Hello, world!' } }
      post = Post.find_by(message: 'Hello, world!')
      expect(post).to be
      expect(post.user_id).to be(user.id)
      expect(post.to_user_id).not_to be
    end
    it 'limits the number of characters in a post' do
      sign_in
      post :create, params: { post: { message: 'He' * 2001 } }
      expect(Post.find_by(message: 'He' * 2001)).not_to be
    end
  end

  describe 'creating wall posts' do
    it 'redirects to user wall' do
      user = sign_in
      post(:wall_create, params: { user_id: user.id, post: { message: 'This is a wall post on my own wall' } })
      expect(response).to redirect_to(user_url(user))
    end

    it 'makes a new post' do
      user = sign_in
      post(:wall_create, params: { user_id: user.id, post: { message: 'This is a wall post on my own wall' } })
      post = Post.find_by(message: 'This is a wall post on my own wall')
      expect(post).to be
      expect(post.user_id).to be(user.id)
      expect(post.to_user_id).to be(user.id)
    end

    it 'makes a new post on a different user wall' do
      user0 = sign_in
      sign_out
      user1 = sign_in
      post(:wall_create, params: { user_id: user0.id, post: { message: 'This is a wall post on a diff wall' } })
      post = Post.find_by(message: 'This is a wall post on a diff wall')
      expect(post.user_id).to eq(user1.id)
      expect(post.to_user_id).to eq(user0.id)
    end

    it 'cannot create wall post over 4000' do
      user = sign_in
      post(:wall_create, params: { user_id: user.id, post: { message: 'He' * 2001 } })
      expect(Post.find_by(message: 'He' * 2001)).not_to be
    end
  end

  describe 'deleting posts' do
    it 'deletes a post' do
      user = sign_in
      post = FactoryBot.create(:post, message: 'you can delete me :(', user_id: user.id)
      delete(:destroy, params: { id: post.id })
      expect(Post.find_by(id: post.id)).not_to be
    end

    it 'cannot delete another users posts' do
      user1 = sign_in
      post = FactoryBot.create(:post, message: "you can't delete me lol", user_id: user1.id)
      sign_out
      user2 = sign_in
      delete :destroy, params: { id: post.id }
      expect(Post.find_by(id: post.id)).to be
    end
  end

  describe 'editing posts' do
    it 'updates a post' do
      user = sign_in
      post = FactoryBot.create(:post, message: 'Hello, world!', user_id: user.id)
      put(:update, params: { id: post.id, post: { message: 'Hello, Dream world' } })
      expect(Post.find_by(id: post.id)).to be
    end

    it 'does not let you update a post to more than 4000 characters' do
      user = sign_in
      post = FactoryBot.create(:post, message: 'Hello, world!', user_id: user.id)
      put(:update, params: { id: post.id, post: { message: 'He' * 2001 } })
      expect(Post.find_by(id: post.id)).to be
      expect(Post.find_by(message: 'He' * 2001)).not_to be
    end
  end
end
