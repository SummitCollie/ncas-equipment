class DashboardsController < ApplicationController
  def index
    authorize(:dashboard, :show)
  end

  private

  def user_not_authorized
    if current_user&.active?
      return super
    end
    flash[:alert] = 'Your account has been disabled. If you believe this is in error, contact NCAS staff.'
    sign_out(current_user)
    redirect_to(new_user_session_url)
  end
end
