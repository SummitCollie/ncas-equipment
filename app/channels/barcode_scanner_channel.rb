class BarcodeScannerChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def barcode_scanned(data)
    barcode = data['barcode']
    asset = Asset.find_by(barcode: barcode)

    if asset.present?
      transmit({
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
end
