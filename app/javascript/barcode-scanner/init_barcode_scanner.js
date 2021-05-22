import CameraManager from 'barcode-scanner/utils/camera_manager';
import BarcodeScanner from 'barcode-scanner/barcode_scanner';
import EventHandler from './utils/event_handler';

const initBarcodeScanner = () => {
  const videoElement = document.getElementById('video-element');
  const eventHandler = new EventHandler();
  const barcodeScanner = new BarcodeScanner(eventHandler);
  const cameraManager = new CameraManager(videoElement, eventHandler);

  cameraManager
    .initVideo()
    .then(() => barcodeScanner.initialize(videoElement).start())
    .catch(err => console.error('initVideo failed:\n', err));
};

export default initBarcodeScanner;
