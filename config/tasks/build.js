import { resolve } from 'path';

import data from './build/data';
import * as sequences from './build/sequences';


const root = resolve(__dirname, '../../');


export default function() {
  const d = { __root__: root };

  return sequences.webpack(d)
    .then((assets) => {
      return data({ ...d, assets });
    })
    .then((metadata) => {
      return Promise.all([
        sequences.staticAssets(metadata),
        sequences.templates(metadata),
        sequences.writings(metadata)
      ]);
    });
}
