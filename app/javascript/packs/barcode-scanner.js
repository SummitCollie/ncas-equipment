/* eslint-disable import/prefer-default-export */
import 'stylesheets/barcode-scanner.scss';

import 'core-js/stable';
import 'regenerator-runtime/runtime';
import Rails from '@rails/ujs';
import Turbolinks from 'turbolinks';
import 'channels';

import '../barcode-scanner/index';

Rails.start();
Turbolinks.start();

export { default as initBarcodeScanner } from 'barcode-scanner/index';
