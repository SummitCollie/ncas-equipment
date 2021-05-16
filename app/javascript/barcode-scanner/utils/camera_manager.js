import showFatalError from 'barcode-scanner/utils/show_fatal_error';

class CameraManager {
  /**
   * @param {HTMLVideoElement} videoElement to render into
   * @param barcodeScanner - the current instance of ./utils/barcode_scanner.js
   *  (unfortunately it needs to be involved in the camera cycle process)
   */
  constructor(videoElement, barcodeScanner) {
    this.videoElement = videoElement;
    this.barcodeScanner = barcodeScanner;
    this.currentStream = null;
    this.cameraIds = new Set();
    this.$switchCamButton = $('.btn-switch-cameras');
    this.isChangingCamera = false;
  }

  /**
   * @returns {Promise<Array<MediaDeviceInfo>} Promise resolving to Array
   *  containing deviceId of each unique camera (some browsers duplicate cams)
   */
  static getFilteredCameraIds() {
    const cameraIds = [];

    return navigator.mediaDevices
      .enumerateDevices()
      .then(devices => {
        const foundCameras = devices.filter(
          device => device.kind === 'videoinput'
        );

        foundCameras.forEach(cam => {
          // Chrome adds a duplicate 'default' device, filter it out
          if (
            cam.deviceId === 'default' &&
            foundCameras.find(c => c.groupId === cam.groupId)
          ) {
            return null;
          }
          cameraIds.push(cam.deviceId);
        });

        return cameraIds;
      })
      .catch(err => {
        console.error('Error getting list of cameras:\n', err);
        return err;
      });
  }

  initVideo() {
    const constraints = {
      video: { facingMode: 'environment' },
      audio: false,
    };
    return navigator.mediaDevices
      .getUserMedia(constraints)
      .then(stream => {
        this.currentStream = stream;
        this.videoElement.srcObject = stream;

        $('.starting-message').css('display', 'none');
        $('.red-bar').css('display', 'block');
      })
      .catch(err => {
        console.error("Couldn't start video:\n", err);

        switch (err.name) {
          case 'NotAllowedError':
            if (err.message === 'Permission dismissed') {
              showFatalError(
                'Camera permission box closed',
                'You closed the camera permissions box! Rude! Refresh the page and click allow next time.<br />( ͡°ᴥ ͡° ʋ)'
              );
              return err;
            }
            showFatalError(
              'Camera permission denied',
              'I asked for camera permissions so nicely and you just said <i><b>no?!</b></i> How inconsiderate!' +
                ' Figure out how tell your browser to allow me camera permission or your barcodes will go unscanned!<br />ʕ ᓀ ᴥ ᓂ ʔ'
            );
            return err;
          case 'NotFoundError':
            showFatalError(
              'No cameras found',
              "Couldn't find any cameras on this device! You kinda need one if you want to scan barcodes v__v" +
                '<br /><br />Maybe privacy settings in your browser or OS are blocking it?'
            );
            return err;
          default:
            showFatalError(
              'Error starting camera',
              'A ~mysterious~ unknown error occurred while trying to access the camera. Make sure no other apps or programs are using it!'
            );
            return err;
        }
      })
      .then(CameraManager.getFilteredCameraIds)
      .catch(err => {
        console.error('Error getting list of cameras:\n', err);
        return err;
      })
      .then(gotDeviceIds => {
        gotDeviceIds.forEach(this.cameraIds.add, this.cameraIds);
        if (this.cameraIds.size > 1) {
          this.$switchCamButton.css('display', 'block');
          this.$switchCamButton.on('click', () =>
            this.isChangingCamera ? null : this.cycleCamera()
          );
        }
      });
  }

  cycleCamera() {
    // Prevent spam-click lagging up the app
    this.isChangingCamera = true;

    const currentCamId = this.currentStream.getVideoTracks()[0].getSettings()
      .deviceId;
    const allCamIds = [...this.cameraIds];

    // Find next camera
    let nextCam;
    allCamIds.forEach((id, index) => {
      if (id === currentCamId) {
        if (index !== allCamIds.length - 1) nextCam = allCamIds[index + 1];
        else nextCam = allCamIds[0]; // eslint-disable-line prefer-destructuring
      }
    });

    // Stop current stream + barcode scanner
    this.stopMediaTracks();

    // Start new stream + barcode scanner
    const newConstraints = {
      video: {
        deviceId: {
          exact: nextCam,
        },
      },
      audio: false,
    };
    navigator.mediaDevices
      .getUserMedia(newConstraints)
      .then(stream => {
        this.currentStream = stream;
        this.videoElement.srcObject = stream;
        this.barcodeScanner
          .initialize(this.videoElement)
          .waitForScanResult(this.videoElement);
      })
      .finally(() => {
        this.isChangingCamera = false;
      });
  }

  stopMediaTracks() {
    this.barcodeScanner.stop();
    this.currentStream.getTracks().forEach(track => {
      track.stop();
    });
  }
}

export default CameraManager;
