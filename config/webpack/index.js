import partial from 'webpack-partial';
import path from 'path';
import webpack from 'webpack';

import fontsConfig from './fonts';
import logsConfig from './logs';
import imagesConfig from './images';
import stylesheetsConfig from './stylesheets';
import javascriptsConfig from './javascripts';

import * as utils from '../utils';


const root = path.resolve(__dirname, '../../');


export default partial(
  {
    entry: [
      path.join(root, 'src/javascripts/application.js'),
      path.join(root, 'src/stylesheets/application.css'),
    ],

    context: root,

    output: {
      filename: (
        utils.isDevelopmentEnv() ?
          'assets/[name].js' :
          'assets/[name].[hash].js'
      ),
      publicPath: '/',
      path: path.join(root, 'build'),
    },

    plugins: [
      utils.isProductionEnv() ?
        [ new webpack.optimize.UglifyJsPlugin({ minimize: true }) ] :
        [],
    ]
  },

  logsConfig,
  fontsConfig,
  imagesConfig,
  stylesheetsConfig,
  javascriptsConfig
);
