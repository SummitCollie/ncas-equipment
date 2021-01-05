module Admin
  module VerifyAdmin
    extend ActiveSupport::Concern

    included do
      before_action :verify_admin
    end

    def verify_admin
      unless current_user&.admin?
        redirect_to(root_path, alert: 'You are not an admin.')
      end
    end
  end
end
