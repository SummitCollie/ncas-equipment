class DashboardsController < ApplicationController
  def index
    skip_policy_scope
    authorize(:dashboard, :show)

    # Temporary: redirect admin users to /admin because the non-admin
    # site doesn't exist yet. Remove when it does.
    if current_user.admin?
      redirect_to(admin_root_url)
    end
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
