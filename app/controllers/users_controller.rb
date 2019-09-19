class UsersController < Clearance::UsersController
  def create
    # completely overwriting it
    @user = user_from_params
    p @user.username
    if @user.username == ""
      flash[:message] = 'You must enter a username to signup!'
      redirect_to sign_up_path and return
    end
    
    if @user.save
      sign_in @user
      flash[:message] = 'A helpful message to say you\'ve been signed in!'
      redirect_back_or url_after_create
    else
      flash[:error] = "Unable to create account"
      redirect_to sign_up_path
    end
  end

  # protected
  def url_after_create
    "/profile"
  end

  def show
    unless User.exists?(params[:id])
      flash[:error] = "That user does not exist"
      redirect_to posts_url
      # redirect_back && return
    end

    @posts = Post.where(
      "(user_id = '#{params[:id]}' and to_user_id is null) or to_user_id = '#{params[:id]}'"
    ).order("created_at DESC")
    @wall_post = Post.new
  end

  private

  def user_from_params
    email = user_params.delete(:email)
    password = user_params.delete(:password)
    username = user_params.delete(:username)

    Clearance.configuration.user_model.new(user_params).tap do |user|
      user.email = email
      user.password = password
      user.username = username
    end
  end

  def user_params
    params[Clearance.configuration.user_parameter] || Hash.new
  end
end
