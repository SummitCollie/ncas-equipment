/* eslint-disable import/prefer-default-export */
/* https://github.com/thoughtbot/administrate/wiki/Rails-6-&-Webpacker */

// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
require('turbolinks').start();

// The next line you only need if you want ActiveStorage support
// require('@rails/activestorage').start();

// The next two lines you only need if you want ActionText support
// require('trix')
// require('@rails/actiontext')

import Rails from '@rails/ujs';
import '../administrate/index';
import 'stylesheets/administrate.scss';

Rails.start();

export { default as initTagsIndex } from 'administrate/tags_index';
export { default as initSearchIndex } from 'administrate/global_search/index';
