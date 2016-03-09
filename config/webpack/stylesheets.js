import ExtractTextPlugin from 'extract-text-webpack-plugin';
import path from 'path';

import cssnext from 'postcss-cssnext';
import functions from 'postcss-functions';
import mixins from 'postcss-mixins';
import normalize from 'postcss-normalize';
import partialImport from 'postcss-partial-import';
import propertyLookup from 'postcss-property-lookup';
import simpleVars from 'postcss-simple-vars';

import * as utils from '../utils';


export default function() {
  return {
    module: {
      loaders: [{
        test: /\.css$/,
        include: path.resolve(__dirname, '../../src'),
        loader: ExtractTextPlugin.extract('style', 'css!postcss?pack=withNormalize'),
      }],
    },

    postcss: () => {
      const defaults = [
        partialImport({
          extension: 'pcss',
          prefix: '',
        }),

        functions({
          functions: {

            // 12px: grid
            // 16px: default font-size
            grid(number) {
              const sizeInRem = parseFloat(number) * (12 / 16);
              // e.g. 1 = 1 column of 12px
              return sizeInRem.toString() + 'rem';
            },

            rem(pixels) {
              const sizeInRem = parseFloat(pixels.replace(/px$/, '')) / 16;
              return sizeInRem.toString() + 'rem';
            },

          },
        }),

        mixins,
        propertyLookup,
        simpleVars,
        cssnext,
      ];

      return {
        defaults,
        withNormalize: [normalize, ...defaults],
      }
    },

    plugins: [
      new ExtractTextPlugin(
        utils.isDevelopmentEnv() ?
          'assets/[name].css' :
          'assets/[name].[hash].css'
      ),
    ]
  };
}
