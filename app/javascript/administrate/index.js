import { render } from 'preact';

import 'jquery-ui';
import 'jquery-ui/ui/widgets/sortable';

import 'selectize';

import '../components/table';
import '../components/date_time_picker';
import initSocketConsumer from './init_socket_consumer';

document.addEventListener('DOMContentLoaded', () => {
  window.socketConsumer = initSocketConsumer();

  // Mount Preact app on pages with a container for it
  const preactContainer = document.getElementById('preact-container--admin');
  if (preactContainer) render(<div>preact works</div>, preactContainer);
});

// Update websocket server with current URL on every page change
document.addEventListener('turbolinks:load', () =>
  window.socketConsumer.navigated()
);
