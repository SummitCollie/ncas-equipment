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
        console.log(`Got data: ${JSON.stringify(data, null, 2)}`);
        eventHandler.emit('got-asset-data', data);
      },

      barcode_scanned(barcode) {
        this.perform('barcode_scanned', { barcode });
      },
    }
  );
};

export default initSocketConsumer;
