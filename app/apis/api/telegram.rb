module API
  class Telegram
    include HTTParty

    attr_accessor :chat_id
    attr_accessor :options
    mattr_reader :stickers, default: {
      thumbs_up: 'CAACAgQAAxkBAAM3YJchASSXyGyiHfymqXr3sYIBYEQAAgIAA6jdCBKv7il3OAKdAx8E',
      wat: 'CAACAgQAAxkBAANoYJdRHsB9ag9RZheMuFFhVb0bY04AAgcAA6jdCBJT9BM6g2HANR8E',
    }

    BOT_TOKEN = Rails.application.credentials.telegram[:bot_token]
    base_uri "https://api.telegram.org/bot#{BOT_TOKEN}"

    def initialize(chat_id)
      @chat_id = chat_id
      @options = { headers: { 'Content-Type': 'application/json' } }
    end

    def send_message(text)
      opts = options.merge({ body: {
        text: text,
        chat_id: chat_id,
        disable_web_page_preview: true,
        parse_mode: 'HTML',
      }.to_json })
      result = self.class.post('/sendMessage', opts)

      unless result.ok?
        Rails.logger.error("Error sending Telegram message:\n#{result}")
      end
    end

    def send_sticker(file_id)
      opts = options.merge({ body: {
        sticker: file_id,
        chat_id: chat_id,
      }.to_json })
      result = self.class.post('/sendSticker', opts)

      unless result.ok?
        Rails.logger.error("Error sending Telegram sticker:\n#{result}")
      end
    end

    def get_stickers_in_set(name)
      opts = options.merge({ body: {
        name: name,
      }.to_json })
      result = self.class.post('/getStickerSet', opts)
      result['result']['stickers']
    end

    def self.connect_webhook
      options = {
        headers: { 'Content-Type': 'application/json' },
        body: {
          url: Rails.application.credentials.base_url +
            Rails.application.routes.url_helpers.telegram_webhook_path(BOT_TOKEN),
          drop_pending_updates: true,
          allowed_updates: ['message', 'my_chat_member'],
        }.to_json,
      }
      post('/setWebhook', options)
      puts('Successfully connected Telegram webhook')
    rescue HTTParty::Error, StandardError
      throw(Error.new("Couldn't connect Telegram webhook"))
    end
  end
end
