import path from 'path';


export default function() {
  return {
    module: {
      loaders: [{
        test: /\.jsx?$/,
        include: path.resolve(__dirname, '../../src'),
        loader: 'babel',
      }],
    },
  };
}
