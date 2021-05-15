import { BrowserMultiFormatReader, DecodeHintType } from '@zxing/library/esm';

const hints = new Map();
hints.set(DecodeHintType.TRY_HARDER, true);

const waitForScanResult = async videoElement => {
  const codeReader = new BrowserMultiFormatReader(hints);

  try {
    const result = await codeReader.decodeFromVideoElement(videoElement);
    $('.message-container').text(result.getText());
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
};

export default waitForScanResult;
