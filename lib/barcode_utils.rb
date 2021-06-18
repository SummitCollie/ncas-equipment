class BarcodeUtils
  # TODO: these need to be used in two places:
  #  * when admin page navigation happens, socket-message goes out to all
  #    barcode scanners running for this user with current action
  #  * when barcode scanner submits action, use this to determine what message
  #    to send to which web channel (and handle it in the JS for that page)
  # rubocop:disable Style/ClassVars
  @@action_types = [
    SET_ASSET_BARCODE = 'set_asset_barcode',
    ADD_TO_CHECKOUT = 'add_to_checkout',
    ADD_TO_CHECKIN = 'add_to_checkin',
    OPEN_ON_PC = 'open_on_pc',
  ]
  # rubocop:enable Style/ClassVars

  def self.action_from_url(url)
    controller, action = Rails.application.routes.recognize_path(url).values_at(:controller, :action)

    if controller == 'admin/assets' && action == 'edit'
      SET_ASSET_BARCODE
    elsif controller == 'admin/checkouts' && action == 'new'
      ADD_TO_CHECKOUT
    elsif controller == 'admin/checkins' && action == 'new'
      ADD_TO_CHECKIN
    else
      OPEN_ON_PC
    end
  end
end
