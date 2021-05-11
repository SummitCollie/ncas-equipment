import { BrowserMultiFormatReader } from '@zxing/browser';

const initBarcodeScanner = () => {
  const videoElement = document.getElementById('video-element');
  // const $cycleCamerasButton = $('#cycle-cameras-button');
  let currentStream;
  let cameras = [];

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
      cameras = devices.filter(device => device.kind === 'videoinput');
    })
    .catch(err => console.error("Couldn't access cameras:\n", err));
};

function stopMediaTracks(stream) {
  stream.getTracks().forEach(track => {
    track.stop();
  });
}

export default initBarcodeScanner;
