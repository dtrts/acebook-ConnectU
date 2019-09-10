class ApplicationController < ActionController::Base
  include Clearance::Controller

  before_action :require_login
  protect_from_forgery with: :exception

  def index; end

  private

  def require_login
    if signed_out? && request.env['PATH_INFO'] != '/'
      flash[:error] = 'You must be logged in to access this section'
      redirect_to('/') # halts request cycle
    end
  end
end
