require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe 'GET /users/:user_id/posts/new ' do
    it 'responds with 200 when signed in' do
      user = sign_in
      get :new, params: { user_id: user.id }
      expect(response).to have_http_status(200)
    end
    it 'redirects when not signed in' do
      get :new, params: { user_id: 0 }
      expect(response).to have_http_status(302)
    end
  end

  describe 'POST /' do
    it 'responds with 200' do
      user = sign_in
      post :create, params: { user_id: user.id, post: { message: 'Hello, world!' } }
      expect(response).to redirect_to(posts_url)
    end

    it 'creates a post' do
      user = sign_in
      post :create, params: { user_id: user.id, post: { message: 'Hello, world!' } }
      expect(Post.find_by(message: 'Hello, world!')).to be
    end

    it 'updates a post' do
      user = sign_in
      post :create, params: { user_id: user.id, post: { message: 'Hello, world!' } }
      put :update, params: { id: Post.first.id, post: { message: 'Hello, Dream world' } }
      expect(Post.find_by(message: 'Hello, Dream world')).to be
    end
    it 'creates a post with correct user_id' do
      user = sign_in
      post(:create, params: { user_id: user.id, post: { message: 'Hello, world!1111' } })
      a_post = Post.find_by(message: 'Hello, world!1111', user_id: user.id)
      expect(a_post).to be
    end
  end

  describe 'GET /' do
    it 'responds with 200' do
      user = sign_in
      get :index, params: { user_id: user.id }
      expect(response).to have_http_status(200)
    end
  end

  describe 'PATCH' do
    it 'will update a post' do
      user = sign_in
      post(:create, params: { user_id: user.id, post: { message: 'Hello, world!123' } })
      post = Post.find_by(message: 'Hello, world!123')
      patch(:update, params: { id: Post.first.id, post: { message: 'Funky town' } })
      expect(Post.find(post.id).message).to eq('Funky town')
    end
    it 'can\'t update another users post' do
      user = sign_in
      post(:create, params: { user_id: user.id, post: { message: 'Hello, world!123' } })
      post = Post.find_by(message: 'Hello, world!123')
      sign_out
      sign_in
      patch(:update, params: { id: Post.first.id, post: { message: 'Funky town' } })
      expect(Post.find(post.id).message).to eq('Hello, world!123')
    end
  end

  describe 'DELETE' do
    it 'will not delete a post of a different user' do
      user = sign_in
      post :create, params: { user_id: user.id, post: { message: 'Hello, world!' } }
      a_post = Post.find_by(message: 'Hello, world!')
      sign_out
      user = sign_in # makes a new user
      delete(:destroy, params: { id: a_post.id })
      expect(Post.find(a_post.id)).to eq(a_post)
    end

    it 'will delete its own post' do
      user = sign_in
      post :create, params: { user_id: user.id, post: { message: 'Hello, world!' } }
      a_post = Post.find_by(message: 'Hello, world!')

      delete(:destroy, params: { id: a_post.id })
      expect(Post.where(id: a_post.id).count).to eq(0)
    end
    it 'deletes a post' do
      user = sign_in
      post :create, params: { user_id: user.id, post: { message: 'Hello, world!' } }
      delete :destroy, params: { id: Post.first.id, post: { message: 'Hello, world!' } }
      expect(Post.find_by(message: 'Hello, world!')).not_to be
    end
  end
end
