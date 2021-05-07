module API
  class Telegram
    include HTTParty

    attr_accessor :chat_id
    attr_accessor :options

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
      }.to_json })
      self.class.post('/sendMessage', opts)
    end
  end
end
