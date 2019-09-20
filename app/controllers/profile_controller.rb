class ProfileController < ApplicationController
  def index
    @post = Post.new
    @_posts = Post.where(:user_id => :user_id)
    @posts = @_posts.reverse
  end

  def show
    @post = Post.new
    @posts = Post.where(:user_id => params[:id]).order("created_at DESC")
  end

end
