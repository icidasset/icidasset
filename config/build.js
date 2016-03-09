import { resolve } from 'path';
import { run } from 'static-base';

import { copy, frontmatter, metadata, pathToRoot, permalinks } from 'static-base-contrib';
import { read, renameExtension, templates, webpack, write } from 'static-base-contrib';

import * as utils from './utils';
import layouts from './base/layouts';
import webpackConfig from './webpack';


const root = resolve(__dirname, '../');


export default function() {
  return build__webpack()
    .then(collectAssets)
    .then(build__templates);
}


function collectAssets(files) {
  const assets = {};

  files.forEach((f) => {
    assets[`${f.basename}${f.extname}`] = f;
  });

  return { assets };
}




/**
 * {private} Build webpack
 */
function build__webpack() {
  return run(
    [webpack, webpackConfig],
    [write, 'build']
  )(
    null,
    root
  );
}


/**
 * {private} Build templates
 */
function build__templates(data = {}) {
  return run(
    [read],
    [frontmatter],
    [metadata, data],
    [pathToRoot],
    [layouts],
    [templates, utils.render],
    [renameExtension, '.html'],
    [permalinks],
    [write, 'build']
  )(
    'src/templates/**/*.ejs',
    root,
  );
}


/**
 * {private} Build static assets
 */
function build__staticAssets() {
  return run(
    [copy, 'build/images']
  )(
    'src/images/**/*',
    root
  );
}
