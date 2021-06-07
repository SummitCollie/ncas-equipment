import { createConsumer } from '@rails/actioncable';

const initSocketConsumer = () => {
  const socketConsumer = createConsumer();

  return socketConsumer.subscriptions.create(
    { channel: 'BarcodeWebChannel' },
    {
      connected() {
        console.log('connected websocket');
      },

      received(data) {
        console.log('got data: ', JSON.stringify(data, null, 2));
      },
    }
  );
};

export default initSocketConsumer;
