require "#{Rails.root}/lib/barcode_utils.rb"

class BarcodeWebChannel < ApplicationCable::Channel
  def subscribed
    # Store connection_identifier in DB as "most recent"
    user = User.find(connection.current_user.id)
    user.update(
      websocket_id: connection.connection_identifier,
      websocket_action: BarcodeUtils.action_from_url(params[:url])
    )
  end

  def unsubscribed
    user = User.find(connection.current_user.id)

    if connection.connection_identifier == user.websocket_id
      # Clear out websocket ID, the "most recent" session ended
      # This may not be 100% reliable but whatever, good enough
      user.update(websocket_id: nil)
    end
  end

  def navigated(data)
    # Store this now "most recent" connection_identifier & current action in DB
    user = User.find(connection.current_user.id)
    user.update(
      websocket_id: connection.connection_identifier,
      websocket_action: BarcodeUtils.action_from_url(data['url'])
    )

    # Broadcast new action to all barcode scanners for this user
    BarcodeScannerChannel.broadcast_to(
      User.find(connection.current_user.id),
      action: BarcodeUtils.action_from_url(data['url'])
    )
  end

  def barcode_submitted
  end
end
