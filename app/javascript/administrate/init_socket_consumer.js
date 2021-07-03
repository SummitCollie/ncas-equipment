import { createConsumer } from '@rails/actioncable';

const initSocketConsumer = () => {
  const socketConsumer = createConsumer();
  let connectionId;

  return socketConsumer.subscriptions.create(
    {
      channel: 'BarcodeScannerChannel',
      url: window.location.pathname,
      desktop_app: true,
    },
    {
      connected() {},

      received(data) {
        if (data.target === 'desktop') {
          switch (data.message_type) {
            case BarcodeApp.message_types.YOUR_CONNECTION_ID:
              connectionId = data.connection_identifier;
              break;

            case BarcodeApp.message_types.ACTION_PERFORMED:
              if (data.websocket_id === connectionId) {
                console.log(
                  `got action performed message with data: ${JSON.stringify(
                    data,
                    null,
                    2
                  )}`
                );
              }
              break;

            default:
              console.error(
                `Got unknown websocket message type '${
                  data.message_type
                }' containing:\n${JSON.stringify(data, null, 2)}`
              );
          }
        } else if (data.target !== 'scanner') {
          console.error(`Got message with unknown target '${data.target}'`);
        }
      },

      navigated() {
        this.perform('navigated', { url: window.location.pathname });
      },
    }
  );
};

export default initSocketConsumer;
