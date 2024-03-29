import initSocketConsumer from 'barcode-scanner/init_socket_consumer';
import CameraManager from 'barcode-scanner/utils/camera_manager';
import BarcodeScanner from 'barcode-scanner/barcode_scanner';
import ActionScreen from 'barcode-scanner/action_screen';
import EventHandler from './utils/event_handler';

const initBarcodeScanner = () => {
  const videoElement = document.getElementById('video-element');
  const eventHandler = new EventHandler();
  const actionScreen = new ActionScreen(eventHandler); // eslint-disable-line no-unused-vars
  const barcodeScanner = new BarcodeScanner(eventHandler);
  const cameraManager = new CameraManager(videoElement, eventHandler);
  initSocketConsumer(eventHandler);

  cameraManager
    .initVideo()
    .then(() => barcodeScanner.initialize(videoElement).start())
    .catch(err => console.error('initVideo failed:\n', err));
};

export default initBarcodeScanner;
