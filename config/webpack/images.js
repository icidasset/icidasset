import path from 'path';


const root = path.resolve(__dirname, '../../');
const source = path.join(root, 'src');
const regex = /\.(gif|jpe?g|png|tiff|svg)$/;


export default function() {
  return {
    module: {
      loaders: [{
        test: regex,
        include: path.join(source, 'images'),
        loader: 'url?limit=10000&name=assets/images/[hash:base64:5]-[name].[ext]',
      }],
    },
  };
}
