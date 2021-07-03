class BarcodeScannerChannel < ApplicationCable::Channel
  def subscribed
    stream_for(current_user)

    # If this is desktop app: store connection_identifier in DB as "most recent"
    if params[:desktop_app].present?
      @desktop_app = true
      user = User.find(connection.current_user.id)
      user.update(
        websocket_id: connection.connection_identifier,
        websocket_action: BarcodeUtils.action_from_url(params[:url])
      )

      # Tell the desktop client what its connection_identifier is so
      # it can filter incoming messages meant for it
      transmit({
        target: 'desktop',
        message_type: BarcodeUtils.message_types[:YOUR_CONNECTION_ID],
        connection_identifier: connection.connection_identifier,
      })

      update_scanner_action(user, BarcodeUtils.action_from_url(params[:url]))
    end
  end

  def unsubscribed
    if @desktop_app
      user = User.find(connection.current_user.id)

      if connection.connection_identifier == user.websocket_id
        # Clear out websocket columns cuz the "most recent" session ended.
        # This may not be 100% reliable but whatever, good enough
        user.update(websocket_id: nil, websocket_action: nil)

        # Also tell barcode apps there's no action anymore
        update_scanner_action(user, nil)
      end
    end
  end

  # --- Barcode scanner app actions ---
  def barcode_scanned(data)
    barcode = data['barcode']
    asset = Asset.find_by(barcode: barcode)

    if asset.present?
      transmit({
        target: 'scanner',
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
    user = User.find(connection.current_user.id)
    action_name = data['actionName']
    barcode = data['barcode']
    asset = Asset.find_by(barcode: barcode)
    raise "Action or barcode was blank, can't do nothin" unless action_name && barcode

    # Tell desktop app to [do thing (action)] with barcode
    # (websocket id has to be filtered on desktop's client-side)
    broadcast_to(
      user,
      target: 'desktop',
      message_type: BarcodeUtils.message_types[:ACTION_PERFORMED],
      websocket_id: user.websocket_id,
      action_name: action_name,
      barcode: barcode,
      asset_id: asset&.id,
    )
  end

  # --- Desktop app actions ---
  def navigated(data)
    # Store this now "most recent" connection_identifier & current action in DB
    user = User.find(connection.current_user.id)
    user.update(
      websocket_id: connection.connection_identifier,
      websocket_action: BarcodeUtils.action_from_url(data['url'])
    )

    update_scanner_action(user, BarcodeUtils.action_from_url(data['url']))
  end

  # Broadcast new action to all barcode scanners for this user
  def update_scanner_action(user, action)
    broadcast_to(
      user,
      target: 'scanner',
      message_type: BarcodeUtils.message_types[:ACTION_CHANGED],
      action: action
    )
  end
end
