module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user, :start_time

    def connect
      self.current_user = find_verified_user
      self.start_time = Time.current
    end

    private

    def find_verified_user
      user_id = cookies.encrypted['_ncas_equipment_session']['warden.user.user.key'][0][0]
      if (verified_user = User.find_by(id: user_id))
        verified_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
