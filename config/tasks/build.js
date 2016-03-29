import { resolve } from 'path';
import { run } from 'static-base';
import { copy, metadata, templates, write } from 'static-base-contrib';

import data from '../metadata';
import render from '../handlebars/render';
import sequences from '../sequences';


export default function() {
  const __root__ = resolve(__dirname, '../../');
  return partOne({ __root__ }).then(partTwo);
}


/**
 * Run webpack and then build the data object
 * that will be passed to all templates.
 */
function partOne(d) {
  return sequences.webpack(d)
    .then(assets => {
      return data({ ...d, assets });
    });
}


/**
 * Build collections and copy static assets.
 */
function partTwo(dataObj) {
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
      buildCollection(collections, 'writings', 'build/writings', { onlyApplyLayout: true }),

      run([copy, `build/images`])('src/images/**/*', dataObj.__root__),
    ]);
  });
}


/**
 * The sequence for building a collection.
 */
function buildCollection(collections, key, destination, options) {
  return run(
    [metadata, { collections }],
    [templates, render, options],
    [write, destination]
  )(
    collections[key]
  );
}
