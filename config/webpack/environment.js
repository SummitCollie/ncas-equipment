const { environment } = require('@rails/webpacker');

environment.loaders.append('jquery', {
  test: require.resolve('jquery'),
  use: [
    {
      loader: 'expose-loader',
      options: { exposes: ['$', 'jQuery', 'jquery-ui'] },
    },
  ],
});

[('sass', 'moduleSass')].forEach(loader => {
  const sassLoader = environment.loaders
    .get(loader)
    .use.find(el => el.loader === 'sass-loader');
  sassLoader.options.implementation = require('sass');
});

environment.config.merge({
  resolve: {
    alias: {
      // Aliasing Preact as React
      // https://preactjs.com/guide/v10/getting-started
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
