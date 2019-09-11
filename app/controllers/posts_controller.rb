class PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def create
    # don't need a guard clause since application controller will redirect if not signed in
    # NOt sure how to add to params but can add to new record before saving
    post_params.key?(:user_id)
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @post.save!
    redirect_to posts_url
  end

  def index
    @posts = params[:user_id] ? Post.where(user_id: params[:user_id]) : Post.all
    @posts.order!(created_at: :desc)
    @user = current_user
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.user_id == current_user.id
      @post.destroy
      flash[:message] = 'Post successfully deleted. Alright then, you keep your secrets.'
    else
      flash[:error] = "Cannot delete another user's posts, no matter how man mistakes they make."
    end
    redirect_to user_posts_url
  end

  def update
    @post = Post.find(params[:id])
    if @post.user_id == current_user.id
      @post.update(post_params)
      flash[:message] = 'Post successfully updated. Just in time!'
    else
      flash[:error] = "Cannot update another user's posts, unfortunately."
    end
    redirect_to user_posts_url
  end

  private

  def post_params
    params.require(:post).permit(:message)
  end
end
