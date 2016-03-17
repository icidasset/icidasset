import collections from './collections';
import meta from './meta';
import quotes from './quotes';
import webpack from './webpack';


export default function(initial) {
  return collections(initial)
    .then(meta)
    .then(quotes)
    .then(webpack)
}
