class SessionsController < Clearance::SessionsController
  protected

  def url_after_create
    "/users/#{@user.id}/posts"
  end
end
