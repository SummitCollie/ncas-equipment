/* eslint-disable max-classes-per-file */
import {
  BrowserMultiFormatReader,
  DecodeHintType,
  BarcodeFormat,
} from '@zxing/library/esm';

const hints = new Map();
hints.set(DecodeHintType.TRY_HARDER, true);
hints.set(DecodeHintType.POSSIBLE_FORMATS, [
  BarcodeFormat.CODE_128,
  BarcodeFormat.EAN_8,
  BarcodeFormat.QR_CODE,
  BarcodeFormat.UPC_A,
]);

/** Extension of BrowserMultiFormatReader which prevents it from killing our HTML5 video element */
class CustomMultiFormatReader extends BrowserMultiFormatReader {
  // https://github.com/zxing-js/library/blob/99525fbf71fc4902424673067a120b0c09197c27/src/browser/BrowserCodeReader.ts#L968
  // eslint-disable-next-line
  _destroyVideoElement() {
    return null;
  }
}

class BarcodeScanner {
  constructor(eventHandler) {
    this.eventHandler = eventHandler;
    this.videoElement = null;
    this.codeReader = null;
    this.stopped = false;

    this.eventHandler.on('camera-stopped', () => this.stop());
    this.eventHandler.on('camera-started', ({ videoElement }) =>
      this.initialize(videoElement).start()
    );
  }

  initialize(videoElement) {
    this.videoElement = videoElement;
    this.codeReader = new CustomMultiFormatReader(hints, 1000);
    return this;
  }

  async start() {
    this.stopped = false;

    try {
      let result;
      result = await this.codeReader.decodeFromVideoElement(this.videoElement);
      await this.onScanResult(result);

      /* eslint-disable no-await-in-loop */
      while (!this.stopped) {
        await this.videoElement
          .play()
          // Wait a sec before scanning again, otherwise paused video frame from
          // last loop will trigger a duplicate scan.
          .then(() => new Promise(resolve => setTimeout(resolve, 1000)));
        result = await this.codeReader.decodeOnce(this.videoElement);
        await this.onScanResult(result);
      }
      /* eslint-enable no-await-in-loop */
    } catch (err) {
      if (
        err.message ===
        'Video stream has ended before any code could be detected.'
      ) {
        console.log('Scanner stopped while switching cameras...');
        return;
      }

      console.error('CodeReader encountered an error:\n', err);
      return Promise.reject(err);
    }
  }

  async onScanResult(result) {
    await this.videoElement.pause();
    $('.message-container').text(result.getText());

    // temporary - wait 3 seconds before scanning another
    return new Promise(resolve => setTimeout(resolve, 3000));
  }

  stop() {
    this.stopped = true;
    this.videoElement = null;
    this.codeReader.stopAsyncDecode();
    this.codeReader = null;
    return this;
  }
}

export default BarcodeScanner;
