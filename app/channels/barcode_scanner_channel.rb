class BarcodeScannerChannel < ApplicationCable::Channel
  def subscribed
    stream_for(current_user)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def barcode_scanned(data)
    barcode = data['barcode']
    asset = Asset.find_by(barcode: barcode)

    if asset.present?
      transmit({
        message_type: BarcodeUtils.message_types[:ASSET_DATA],
        id: asset.id,
        name: asset.name,
        description: asset.description,
        locked: asset.locked,
        location: asset.location.present? ? "#{asset.location.event.name} - #{asset.location.name}" : nil,
        user: asset.user.present? ? (asset.user&.display_name || asset.user&.email) : nil,
        tags: asset.tags.map { |tag| { name: tag.name, color: tag.color } },
      })
    end
  end

  def confirm_action(data)
    action = data['action']
    barcode = data['barcode']
    asset = Asset.find_by(barcode: barcode)
    raise "Action or barcode was blank, can't do nothin" unless action && barcode

    # TODO: this doesn't work. Server can't broadcast to the other channel.
    # Possible solution: only keep one channel `barcodes_#{user_id}` for both web AND scanner
    # and assign a UUID for latest active web channel, filter events targeted @ it via events on client side?
    ActionCable.server.broadcast(
      connection.current_user.websocket_id,
      message_type: 'confirm-action',
      action: action,
      barcode: barcode,
      asset: asset # Might be blank if barcode isn't known
      # TODO: might not want to put whole asset in here, just ID.
    )
  end
end
