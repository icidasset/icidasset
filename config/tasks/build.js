import { resolve } from 'path';
import { run } from 'static-base';
import { copy, metadata, templates, write } from 'static-base-contrib';

import data from '../metadata';
import sequences from '../sequences';

import render from '../handlebars/render';


const root = resolve(__dirname, '../../');


export default function() {
  const d = { __root__: root };

  return sequences.webpack(d)
    .then((assets) => {
      return data({ ...d, assets });
    })
    .then((dataObj) => {
      return Promise.all([
        sequences.collections.pages(dataObj),
        sequences.collections.writings(dataObj)
      ]).then(dictionaries => {
        const collections = {
          pages: dictionaries[0],
          writings: dictionaries[1],
        };

        return Promise.all([
          buildCollection(collections, 'pages', 'build'),
          buildCollection(collections, 'writings', 'build/writings'),

          run([copy, `build/images`])('src/images/**/*', root),
        ]);
      });
    });
}


function buildCollection(collections, key, destination) {
  return run(
    [metadata, { collections }],
    [templates, render],
    [write, destination]
  )(
    collections[key]
  );
}
