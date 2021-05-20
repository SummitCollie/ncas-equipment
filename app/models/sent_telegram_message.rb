class SentTelegramMessage < ApplicationRecord
  belongs_to :user

  before_destroy :delete_from_api

  private

  def delete_from_api
    telegram = API::Telegram.new(user)
    telegram.delete_message(message_id)
  end
end
