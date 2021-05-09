class BarcodesController < ApplicationController
  skip_before_action :authenticate_user!, only: :start_scanner
  before_action :skip_authorization, only: :start_scanner

  # Handles magic token auth
  def start_scanner
    return redirect_to(barcodes_scanner_path) if current_user.present?

    magic_token = MagicToken.where(token: params[:token], purpose: 'scan-barcodes').first
    unless magic_token.present?
      @error_title = 'Unable to authenticate!'
      @error_text = 'Maybe the link you used has expired or was used already?'\
      ' Try generating another one.'
      return render('barcodes/error')
    end

    sign_in(magic_token.user)
    magic_token.destroy
    redirect_to(barcodes_scanner_path)
  end

  def scanner
    authorize(:asset, :show?)

    render('barcodes/scanner')
  end
end
