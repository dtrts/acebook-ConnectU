class PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def create
    # don't need a guard clause since application controller will redirect if not signed in
    # p 'creating'
    # post_params[:user_id] = current_user.id
    # NOt sure how to add to params but can add to new record before saving
    # p post_params
    post_params.key?(:user_id)
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    # p @post
    @post.save!
    redirect_to posts_url
  end

  def index
    @posts = Post.all.order(created_at: :desc)
  end

  private

  def post_params
    params.require(:post).permit(:message)
  end
end
