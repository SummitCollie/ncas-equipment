class BarcodeWebChannel < ApplicationCable::Channel
  def subscribed
    ActionCableConnection.create(
      connection_identifier: connection.connection_identifier,
      user_id: connection.current_user.id,
      last_used: connection.started_at,
    )
  end

  def unsubscribed
    ActionCableConnection.find_by(connection_identifier: connection.connection_identifier).destroy!
  end

  def barcode_submitted
  end
end
