// Preact dev tools
if (process.env.NODE_ENV === 'development') require('preact/debug');

import { render } from 'preact';
import { Router } from 'preact-router';
import AsyncRoute from 'preact-async-route';
import 'jquery-ui';
import 'jquery-ui/ui/widgets/sortable';
import 'selectize';

import 'components/table';
import 'components/date_time_picker';
import initSocketConsumer from './init_socket_consumer';
import LoadingIndicator from 'components/LoadingIndicator.jsx';

document.addEventListener('DOMContentLoaded', () => {
  window.socketConsumer = initSocketConsumer();

  // Mount Preact app on pages with a container for it
  const preactContainer = document.getElementById('preact-container--admin');
  if (preactContainer)
    render(
      <div class="preact-wrapper--admin">
        <Router>
          <AsyncRoute
            path="/admin/search"
            loading={LoadingIndicator}
            getComponent={() =>
              new Promise(resolve => setTimeout(resolve, 1500))
                .then(() => import('./global_search'))
                .then(module => module.default)
            }
          />
        </Router>
      </div>,
      preactContainer
    );
});

// Update websocket server with current URL on every page change
document.addEventListener('turbolinks:load', () =>
  window.socketConsumer.navigated()
);
