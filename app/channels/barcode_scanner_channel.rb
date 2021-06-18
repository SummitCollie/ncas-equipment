require "#{Rails.root}/lib/barcode_utils.rb"

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
end
