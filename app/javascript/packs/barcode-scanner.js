/* eslint-disable import/prefer-default-export */
import 'stylesheets/barcode-scanner.scss';

import 'core-js/stable';
import 'regenerator-runtime/runtime';
import Rails from '@rails/ujs';
import Turbolinks from 'turbolinks';

// Support alternative browsers in iOS < 14.3
// eslint-disable-next-line no-unused-vars
import adapter from 'webrtc-adapter';

import '../barcode-scanner/index';

Rails.start();
Turbolinks.start();

export { default as initBarcodeScanner } from 'barcode-scanner/init_barcode_scanner';
