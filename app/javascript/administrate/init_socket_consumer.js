import { createConsumer } from '@rails/actioncable';

const initSocketConsumer = () => {
  const socketConsumer = createConsumer();

  return socketConsumer.subscriptions.create(
    { channel: 'BarcodeWebChannel', url: window.location.pathname },
    {
      connected() {},

      received(data) {
        console.log('got data: ', JSON.stringify(data, null, 2));
      },

      navigated() {
        this.perform('navigated', { url: window.location.pathname });
      },
    }
  );
};

export default initSocketConsumer;
