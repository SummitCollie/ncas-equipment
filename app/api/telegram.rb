module API
  class Telegram
    attr_accessor :chat_id
    attr_accessor :options

    include HTTParty
    BOT_TOKEN = Rails.application.credentials.telegram[:bot_token]
    base_uri "https://api.telegram.org/bot#{BOT_TOKEN}"

    def initialize(chat_id)
      @chat_id = chat_id
      @options = { headers: { 'Content-Type': 'application/json' } }
    end

    def send_message(text)
      opts = options.merge({ body: {
        chat_id: chat_id,
        text: text,
      }.to_json })
      self.class.post('/sendMessage', opts)
    end
  end
end
