import { BrowserMultiFormatReader } from '@zxing/browser';

const initBarcodeScanner = () => {
  const videoElement = document.getElementById('video-element');
  // const $cycleCamerasButton = $('#cycle-cameras-button');
  let currentStream;
  let cameraGroupIds = new Set();

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

      return navigator.mediaDevices.enumerateDevices();
    })
    .then(devices => {
      const detectedCams = devices.filter(
        device => device.kind === 'videoinput'
      );
      detectedCams.forEach(cam => cameraGroupIds.add(cam.groupId));

      if (cameraGroupIds.size > 1) {
        $switchCamButton.css('display', 'block');
      }
    })
    .catch(err => console.error("Couldn't access cameras:\n", err));

  function switchCamera() {
    const currentGroupId = currentStream.getVideoTracks()[0].getSettings()
      .groupId;
    const groupIds = [...cameraGroupIds];

    // Find next camera
    let nextCam;
    groupIds.forEach((id, index) => {
      if (id === currentGroupId) {
        if (index !== groupIds.length - 1) nextCam = groupIds[index + 1];
        else nextCam = groupIds[0]; // eslint-disable-line prefer-destructuring
      }
    });

    // Stop current stream
    stopMediaTracks(currentStream);

    // Start new stream
    const newConstraints = {
      video: {
        groupId: {
          exact: nextCam,
        },
      },
      audio: false,
    };
    navigator.mediaDevices.getUserMedia(newConstraints).then(stream => {
      currentStream = stream;
      videoElement.srcObject = stream;
    });
  }
};

function stopMediaTracks(stream) {
  stream.getTracks().forEach(track => {
    track.stop();
  });
}

export default initBarcodeScanner;
