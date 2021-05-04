require 'administrate/field/base'

class TelegramUsernameField < Administrate::Field::Base
  def to_s
    data
  end
end
