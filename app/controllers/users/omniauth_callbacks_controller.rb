# Handles Omniauth callbacks
# rubocop:disable Style/ClassAndModuleChildren
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Devise::Controllers::Rememberable

  # rubocop:disable Metrics/AbcSize
  def google_oauth2
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user&.persisted?
      remember_me(@user)
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
      sign_in_and_redirect @user, event: :authentication
    else
      # Removing extra as it can overflow some session stores
      session['devise.google_data'] = request.env['omniauth.auth'].except('extra')
      redirect_to new_user_session_url, alert: 'Account not authorized, contact admins'
    end
  end
  # rubocop:enable Metrics/AbcSize
end
# rubocop:enable Style/ClassAndModuleChildren
