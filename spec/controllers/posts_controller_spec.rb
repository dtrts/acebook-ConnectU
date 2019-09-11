require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe 'GET /new ' do
    it 'responds with 200 when signed in' do
      sign_in
      get :new
      expect(response).to have_http_status(200)
    end
    it 'redirects when not signed in' do
      get :new
      expect(response).to have_http_status(302)
    end
  end

  describe 'POST /' do
    it 'responds with 200' do
      sign_in
      post :create, params: { post: { message: 'Hello, world!' } }
      expect(response).to redirect_to(posts_url)
    end

    it 'creates a post' do
      sign_in
      post :create, params: { post: { message: 'Hello, world!' } }
      expect(Post.find_by(message: 'Hello, world!')).to be
    end
    it 'creates a post with correct user_id' do
      user = sign_in
      post(:create, params: { post: { message: 'Hello, world!1111' } })
      a_post = Post.find_by(message: 'Hello, world!1111', user_id: user.id)
      expect(a_post).to be
    end
  end

  describe 'GET /' do
    it 'responds with 200' do
      sign_in
      get :index
      expect(response).to have_http_status(200)
    end
  end

  describe 'PATCH' do
    it 'will update a post' do
      user = sign_in
      post(:create, params: { post: { message: 'Hello, world!123' } })
      post = Post.find_by(message: 'Hello, world!123')
      patch(:update, params: { id: Post.first.id, post: { message: 'Funky town' } })
      expect(Post.find(post.id).message).to eq('Funky town')
    end
    it 'can\'t update another users post' do
      user = sign_in
      post(:create, params: { post: { message: 'Hello, world!123' } })
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
      post :create, params: { post: { message: 'Hello, world!' } }
      a_post = Post.find_by(message: 'Hello, world!')
      sign_out
      user = sign_in # makes a new user
      post :destroy, params: { id: a_post.id }
      expect(Post.find(a_post.id)).to eq(a_post)
    end

    it 'will delete its own post' do
      user = sign_in
      post :create, params: { post: { message: 'Hello, world!' } }
      a_post = Post.find_by(message: 'Hello, world!')

      post :destroy, params: { id: a_post.id }
      expect(Post.where(id: a_post.id).count).to eq(0)
    end
  end
end
