class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!
  before_action :skip_authorization

  TELEGRAM_BOT_TOKEN = Rails.application.credentials.telegram[:bot_token]

  def telegram
    return head(:unauthorized) unless params[:token] == TELEGRAM_BOT_TOKEN
    return head(:no_content) unless params.dig(:message, :chat, :type) == 'private'
    head(:ok)

    case params.dig(:message, :text)
    when %r{^\/start (.+)}
      magic_token = MagicToken.where(
        token: Regexp.last_match(1),
        purpose: 'connect-telegram'
      ).first
      user = magic_token.user
      user.update!(
        telegram: params.dig(:message, :chat, :username),
        telegram_chat_id: params.dig(:message, :chat, :id)
      )

      telegram_api = API::Telegram.new(user.telegram_chat_id)
      telegram_api.send_sticker(API::Telegram.stickers[:thumbs_up])
      telegram_api.send_message(
        <<~HEREDOC
          owo! Your ncas.equipment account has been linked!

          Refresh your user page and you should see your Telegram name.
        HEREDOC
      )

      magic_token.destroy!
    else
      Rails.logger.warn("Don't know how to handle bot message '#{params.dig(:message, :text)}'")
    end
  end
end
