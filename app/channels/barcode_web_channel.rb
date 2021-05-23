class BarcodeWebChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def barcode_scanned(barcode)
    puts "got barcode #{barcode}"
  end

  def barcode_submitted
  end
end
