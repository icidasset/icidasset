import path from 'path';


export default function() {
  return {
    module: {
      loaders: [{
        test: /\.jsx?$/,
        include: path.resolve(__dirname, '../../src'),
        loader: 'babel',
      }, {
        test: /ez\.js$/,
        include: path.resolve(__dirname, '../../node_modules/ez.js'),
        loader: 'babel',
      }],
    },
  };
}
