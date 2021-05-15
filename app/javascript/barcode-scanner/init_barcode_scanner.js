import getFilteredCameraIds from 'barcode-scanner/utils/get_filtered_camera_ids';
import waitForScanResult from 'barcode-scanner/wait_for_scan_result';

const initBarcodeScanner = () => {
  let currentStream;
  const videoElement = document.getElementById('video-element');
  let cameraIds = new Set();

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

      waitForScanResult(videoElement);
    })
    .catch(err => console.error("Couldn't access cameras:\n", err));

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
      waitForScanResult(videoElement);
    });
  }
};

function stopMediaTracks(stream) {
  stream.getTracks().forEach(track => {
    track.stop();
  });
}

export default initBarcodeScanner;
