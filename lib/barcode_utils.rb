class BarcodeUtils
  cattr_reader :action_types
  cattr_reader :message_types

  class << self
    # rubocop:disable Style/ClassVars
    # Types of actions that can be taken on a scanned barcode
    @@action_types = {
      SET_ASSET_BARCODE: 'set_asset_barcode',
      ADD_TO_CHECKOUT: 'add_to_checkout',
      ADD_TO_CHECKIN: 'add_to_checkin',
      OPEN_ON_PC: 'open_on_pc',
    }

    # Tags for websocket messages so clients know what to do with them
    @@message_types = {
      # For scanner app
      ASSET_DATA: 'asset_data',
      ACTION_CHANGED: 'action_changed',

      # For desktop app
      YOUR_CONNECTION_ID: 'your_connection_id',
      ACTION_PERFORMED: 'action_performed',
    }
    # rubocop:enable Style/ClassVars

    def action_from_url(url)
      controller, action = Rails.application.routes.recognize_path(url).values_at(:controller, :action)

      if controller == 'admin/assets' && action.in?(['edit', 'new'])
        @@action_types[:SET_ASSET_BARCODE]
      elsif controller == 'admin/checkouts' && action == 'new'
        @@action_types[:ADD_TO_CHECKOUT]
      elsif controller == 'admin/checkins' && action == 'new'
        @@action_types[:ADD_TO_CHECKIN]
      else
        @@action_types[:OPEN_ON_PC]
      end
    end
  end
end
