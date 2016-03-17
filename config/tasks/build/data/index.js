import collections from './collections';
import env from './env';
import meta from './meta';
import quotes from './quotes';
import webpack from './webpack';


export default function(initial) {
  return collections(initial)
    .then(env)
    .then(meta)
    .then(quotes)
    .then(webpack)
}
