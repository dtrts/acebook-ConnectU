class SessionsController < Clearance::SessionsController
  protected

  def url_after_create
    user_posts_url
  end
end
