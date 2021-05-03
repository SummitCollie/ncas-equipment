class ApplicationController < ActionController::Base
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protect_from_forgery
  before_action :store_user_location!, if: :storable_location?
  before_action :authenticate_user!
  after_action :verify_authorized, unless: :devise_controller?, except: :index
  after_action :verify_policy_scoped, only: :index

  private

  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    sign_out(current_user)
    redirect_to(new_user_session_url)
  end

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || super
  end
end
