import collections from './collections';
import meta from './meta';
import webpack from './webpack';


export default function(initial) {
  return collections(initial)
    .then(meta)
    .then(webpack)
}
