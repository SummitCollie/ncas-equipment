process.env.NODE_ENV = process.env.NODE_ENV || 'development';

const environment = require('./environment');

const { CleanWebpackPlugin } = require('clean-webpack-plugin');
environment.plugins.append('CleanWebpackPlugin', new CleanWebpackPlugin());

module.exports = environment.toWebpackConfig();
