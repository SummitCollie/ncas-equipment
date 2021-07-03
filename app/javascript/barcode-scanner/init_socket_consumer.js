import { createConsumer } from '@rails/actioncable';

const initSocketConsumer = eventHandler => {
  const socketConsumer = createConsumer();
  let lastScannedBarcode = null;

  return socketConsumer.subscriptions.create(
    { channel: 'BarcodeScannerChannel' },
    {
      connected() {
        eventHandler.on('barcode-scanned', barcode => {
          lastScannedBarcode = barcode;
          this.barcode_scanned(barcode);
        });
        eventHandler.on('confirm-action', action =>
          this.confirm_action(action, lastScannedBarcode)
        );
      },

      received(data) {
        switch (data.message_type) {
          case BarcodeApp.message_types.ACTION_CHANGED:
            eventHandler.emit('action-changed', data.action);
            break;

          case BarcodeApp.message_types.ASSET_DATA:
            eventHandler.emit('got-asset-data', data);
            break;

          default:
            console.error(
              `Got unknown websocket message type '${
                data.message_type
              }' containing:\n${JSON.stringify(data, null, 2)}`
            );
        }
      },

      /**
       * A barcode was scanned, send it to the server.
       * The server will fire another event with result data.
       */
      barcode_scanned(barcode) {
        this.perform('barcode_scanned', { barcode });
      },

      /**
       * Send a message back to the server that user wants to perform the current action
       * on the current barcode (set barcode on asset, add it to checkout, etc).
       * The JS on the other end of user's BarcodeWebChannel will deal with it.
       */
      confirm_action(action, barcode) {
        this.perform('confirm_action', { action, barcode });
      },
    }
  );
};

export default initSocketConsumer;
