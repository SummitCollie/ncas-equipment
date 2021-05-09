class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!
  before_action :skip_authorization

  TELEGRAM_BOT_TOKEN = Rails.application.credentials.telegram[:bot_token]

  def telegram
    # Make sure it's actually Telegram contacting us
    return head(:unauthorized) unless params[:token] == TELEGRAM_BOT_TOKEN

    # Handle user blocking bot
    if params.dig(:my_chat_member, :new_chat_member, :status) == 'kicked'
      linked_user = User.find_by(telegram_chat_id: params.dig(:my_chat_member, :chat, :id))
      linked_user.update(telegram: nil, telegram_chat_id: nil)
      return head(:ok)
    end

    # Do nothing outside of private chats
    return head(:no_content) unless params.dig(:message, :chat, :type) == 'private'

    telegram = API::Telegram.new(params.dig(:message, :chat, :id))

    # Handle messages
    case params.dig(:message, :text)

    # User ran /start command with connect_telegram magic token
    when %r{^\/start(?: (.+))?}
      magic_token = MagicToken.where(
        token: Regexp.last_match(1),
        purpose: 'connect-telegram'
      ).first

      unless magic_token.present?
        telegram.send_message(
          <<~HEREDOC
            I couldn't figure out which user to link with this Telegram account :(

            You've gotta use the link on your Edit User page to start this bot,
            just running the /start command won't work.
          HEREDOC
        )
      end

      user = magic_token.user
      user.update!(
        telegram: params.dig(:message, :chat, :username),
        telegram_chat_id: params.dig(:message, :chat, :id)
      )

      telegram.send_sticker(API::Telegram.stickers[:thumbs_up])
      telegram.send_message(
        <<~HEREDOC
          owo! Your ncas.equipment account has been linked!

          Refresh your user page and you should see your Telegram name.
        HEREDOC
      )

      magic_token.destroy!
    when 'owo', 'uwu', 'OwO', 'UwU'
      sticker_set = telegram.get_sticker_set('uwumatedStickers')
      telegram.send_sticker(sticker_set[:stickers].sample.file_id)
    else
      Rails.logger.warn("Don't know how to handle bot message '#{params.dig(:message, :text)}'")
      telegram.send_sticker(API::Telegram.stickers[:wat])
      telegram.send_message(
        <<~HEREDOC
          I don't know how to respond to messages :<
          but thank you for talking to me :3
        HEREDOC
      )
    end

    head(:ok)
  end
end
