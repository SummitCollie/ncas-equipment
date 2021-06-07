import jQuery from 'jquery';
import 'jquery-ui';
import 'jquery-ui/ui/widgets/sortable';

import 'selectize';

import '../components/table';
import '../components/date_time_picker';
import initSocketConsumer from './init_socket_consumer';

window.$ = window.jQuery = jQuery; // eslint-disable-line no-multi-assign

document.addEventListener('turbolinks:load', () => initSocketConsumer());
