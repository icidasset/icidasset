import path from 'path';


export default function() {
  return {
    module: {
      loaders: [{
        test: /\.(woff|ttf|otf|svg|eot)$/,
        include: path.resolve(__dirname, '../../src/fonts'),
        loader: 'url?limit=10000&name=assets/fonts/[hash:base64:5]-[name].[ext]',
      }],
    },
  };
}
