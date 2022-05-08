const webpack = require('webpack'); // eslint-disable-line import/no-extraneous-dependencies
const { environment } = require('@rails/webpacker');

environment.plugins.append(
  'jquery', // arbitrary
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Popper: ['popper.js', 'default'],
  })
);

environment.loaders.append('jquery', {
  test: require.resolve('jquery'),
  use: [
    { loader: 'expose-loader', options: { exposes: 'jQuery' } },
    { loader: 'expose-loader', options: { exposes: '$' } },
  ],
});

environment.config.merge({
  resolve: {
    // Aliasing Preact to React
    // https://preactjs.com/guide/v10/getting-started
    alias: {
      react: 'preact/compat',
      'react-dom/test-utils': 'preact/test-utils',
      'react-dom': 'preact/compat', // Must be below test-utils
      'react/jsx-runtime': 'preact/jsx-runtime',
    },
  },
  output: {
    // Makes exports from entry packs available to global scope, e.g.
    // Packs.application.myFunction
    // Packs.administrate.initTagsIndex(FULL_TAG_LIST)
    library: ['Packs', '[name]'],
    libraryTarget: 'var',
  },
});

module.exports = environment;
