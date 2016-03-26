import env from './env';
import meta from './meta';
import quotes from './quotes';
import webpack from './webpack';


export default function(initial) {
  return env(initial)
    .then(meta)
    .then(quotes)
    .then(webpack)
}
