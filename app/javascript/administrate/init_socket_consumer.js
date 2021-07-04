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
          // Ignore messages that aren't intended for this instance
          // (and aren't YOUR_CONNECTION_ID messages which set our instance ID)
          if (
            data.websocket_id !== connectionId &&
            data.message_type !== BarcodeApp.message_types.YOUR_CONNECTION_ID
          ) {
            return;
          }

          switch (data.message_type) {
            case BarcodeApp.message_types.YOUR_CONNECTION_ID:
              connectionId = data.connection_identifier;
              break;

            case BarcodeApp.message_types.ACTION_PERFORMED:
              switch (data.action_type) {
                case BarcodeApp.action_types.SET_ASSET_BARCODE:
                  $('#asset_barcode').val(data.barcode);
                  break;
                case BarcodeApp.action_types.ADD_TO_CHECKOUT:
                  break;
                case BarcodeApp.action_types.ADD_TO_CHECKIN:
                  break;
                case BarcodeApp.action_types.OPEN_ON_PC:
                  openOnPC(data.asset_id);
                  break;
                default:
                  console.error(
                    `Got unhandled action_type ${data.action_type}`
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

/* Perform actions submitted by scanner */

function openOnPC(assetId) {
  if (!assetId) {
    console.error(`Tried to openOnPC undefined assetId '${assetId}'`);
    return;
  }
  window.location.href = `${BarcodeApp.asset_base_path}/${assetId}`;
}

export default initSocketConsumer;
