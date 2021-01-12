const webpack = require('webpack');
const { environment } = require('@rails/webpacker')

environment.plugins.append(
  'jquery', // arbitrary
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Popper: ['popper.js', 'default'],
  }),
);

environment.loaders.append(
  'jquery',
  {
    test: require.resolve('jquery'),
    use: [
      { loader: 'expose-loader', options: { exposes: 'jQuery' }},
      { loader: 'expose-loader', options: { exposes: '$' }},
    ]
  }
);

module.exports = environment;
