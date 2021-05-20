class BarcodesController < ApplicationController
  skip_before_action :authenticate_user!, only: :start_scanner
  before_action :skip_authorization, only: :start_scanner

  BASE_URL = Rails.application.credentials.base_url

  # Handles magic token auth
  def start_scanner
    sign_out(current_user) if current_user.present?

    magic_token = MagicToken.where(token: params[:token], purpose: 'scan-barcodes').first
    unless magic_token.present?
      @error_title = 'Unable to authenticate!'
      @error_text = 'Maybe the link you used has expired or was used already?'\
        ' Try generating another one.'
      return render('barcodes/error')
    end

    sign_in(magic_token.user)

    # Delete any outgoing Telegram messages with purpose: 'scan-barcodes'
    SentTelegramMessage.where(
      user: magic_token.user,
      purpose: 'scan-barcodes'
    ).destroy_all

    magic_token.destroy
    redirect_to(barcodes_scanner_path)
  end

  def send_telegram_link
    authorize(:asset, :show?)

    token = MagicToken.create(user: current_user, purpose: 'scan-barcodes').token
    link = BASE_URL + start_barcode_scanner_path(token)

    telegram = API::Telegram.new(current_user)
    result = telegram.send_message(
      <<~HEREDOC
        Here's a link that will auto-login and start the barcode scanner:

        #{link}

        Don't share it! Also, it only works one time!
      HEREDOC
    )

    # Save the message_id so we can delete it after use
    SentTelegramMessage.create(
      user: current_user,
      message_id: result.dig('result', 'message_id'),
      purpose: 'scan-barcodes',
    )

    head(:ok)
  end

  def scanner
    authorize(:asset, :show?)

    render('barcodes/scanner')
  end
end
