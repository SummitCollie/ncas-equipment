import getFilteredCameraIds from 'barcode-scanner/utils/get_filtered_camera_ids';
import BarcodeScanner from 'barcode-scanner/barcode_scanner';

const initBarcodeScanner = () => {
  let currentStream;
  let cameraIds = new Set();
  const videoElement = document.getElementById('video-element');
  const barcodeScanner = new BarcodeScanner();

  const $switchCamButton = $('.btn-switch-cameras');
  $switchCamButton.on('click', switchCamera);

  // Init video on page load
  const constraints = {
    video: { facingMode: 'environment' },
    audio: false,
  };
  navigator.mediaDevices
    .getUserMedia(constraints)
    .then(stream => {
      currentStream = stream;
      videoElement.srcObject = stream;

      $('.starting-message').css('display', 'none');
      $('.red-bar').css('display', 'block');

      return getFilteredCameraIds();
    })
    .then(cameraDeviceIds => {
      cameraIds = cameraDeviceIds;
      if (cameraIds.size > 1) {
        $switchCamButton.css('display', 'block');
      }

      barcodeScanner.initialize(videoElement).waitForScanResult(videoElement);
    })
    .catch(err => {
      console.error("Couldn't access cameras:\n", err);

      switch (err.name) {
        case 'NotAllowedError':
          if (err.message === 'Permission dismissed') {
            return showFatalError(
              'Camera permission box closed',
              'You closed the camera permissions box! Rude! Refresh the page and click allow next time.<br />( ͡°ᴥ ͡° ʋ)'
            );
          }
          return showFatalError(
            'Camera permission denied',
            'I asked for camera permissions and you said no?! How silly! Figure out how tell your browser to allow me camera permission or your barcodes will go unscanned!<br />ʕ ᓀ ᴥ ᓂ ʔ'
          );
        case DOMException.NOT_FOUND_ERR:
          return showFatalError(
            'No cameras found',
            "Couldn't find any cameras on this device! You kinda need one if you want to scan barcodes v__v"
          );
        default:
          return showFatalError(
            'Error starting camera',
            'A ~mysterious~ unknown error occurred while trying to access the camera. Make sure no other apps or programs are using it!'
          );
      }
    });

  function switchCamera() {
    const currentCamId = currentStream.getVideoTracks()[0].getSettings()
      .deviceId;
    const allCamIds = [...cameraIds];

    // Find next camera
    let nextCam;
    allCamIds.forEach((id, index) => {
      if (id === currentCamId) {
        if (index !== allCamIds.length - 1) nextCam = allCamIds[index + 1];
        else nextCam = allCamIds[0]; // eslint-disable-line prefer-destructuring
      }
    });

    // Stop current stream
    barcodeScanner.stop();
    stopMediaTracks(currentStream);

    // Start new stream
    const newConstraints = {
      video: {
        deviceId: {
          exact: nextCam,
        },
      },
      audio: false,
    };
    navigator.mediaDevices.getUserMedia(newConstraints).then(stream => {
      currentStream = stream;
      videoElement.srcObject = stream;
      barcodeScanner.initialize(videoElement).waitForScanResult(videoElement);
    });
  }
};

function stopMediaTracks(stream) {
  stream.getTracks().forEach(track => {
    track.stop();
  });
}

function showFatalError(title, text) {
  $('.starting-message').css('display', 'none');

  const $errorContainer = $('.barcode-scanner-error');
  $errorContainer.find('.error-title').text(title);
  $errorContainer.find('.error-text').html(text);
  $errorContainer.css('display', 'block');
}

export default initBarcodeScanner;
