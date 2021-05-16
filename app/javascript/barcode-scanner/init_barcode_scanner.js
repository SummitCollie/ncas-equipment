import CameraManager from 'barcode-scanner/utils/camera_manager';
import BarcodeScanner from 'barcode-scanner/barcode_scanner';

const initBarcodeScanner = () => {
  const videoElement = document.getElementById('video-element');
  const barcodeScanner = new BarcodeScanner();
  const cameraManager = new CameraManager(videoElement, barcodeScanner);

  cameraManager
    .initVideo()
    .then(() => barcodeScanner.initialize(videoElement).waitForScanResult())
    .catch(err => console.error('initVideo failed:\n', err));
};

export default initBarcodeScanner;
