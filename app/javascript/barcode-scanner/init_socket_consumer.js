import { createConsumer } from '@rails/actioncable';

const initSocketConsumer = eventHandler => {
  const socketConsumer = createConsumer();

  return socketConsumer.subscriptions.create(
    { channel: 'BarcodeScannerChannel' },
    {
      connected() {
        eventHandler.on('barcode-scanned', barcode =>
          this.barcode_scanned(barcode)
        );
      },

      received(data) {
        switch (data.message_type) {
          case BarcodeApp.message_types.ACTION_CHANGED:
            console.log(`new action: ${data.action}`);
            break;

          case BarcodeApp.message_types.ASSET_DATA:
            eventHandler.emit('got-asset-data', data);
            break;

          default:
            console.error(
              `Got unknown websocket message type '${data.message_type}'`
            );
        }
      },

      barcode_scanned(barcode) {
        this.perform('barcode_scanned', { barcode });
      },
    }
  );
};

export default initSocketConsumer;
