class ApplicationController < ActionController::Base
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protect_from_forgery
  before_action :authenticate_user!
  after_action :verify_authorized, unless: :devise_controller?

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    sign_out(current_user)
    redirect_to(new_user_session_url)
  end
end
