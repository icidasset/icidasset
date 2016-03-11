import { join, resolve } from 'path';
import { run } from 'static-base';
import fs from 'fs';
import toml from 'toml';

import { copy, frontmatter, metadata, pathToRoot, permalinks } from 'static-base-contrib';
import { read, renameExtension, templates, webpack, write } from 'static-base-contrib';

import * as utils from '../utils';
import render from '../handlebars/render';
import webpackConfig from '../webpack';

import evilIcons from '../base/evil-icons';
import layouts from '../base/layouts';


const root = resolve(__dirname, '../../');


export default function() {
  return build__webpack()
    .then(collectAdditionalData)
    .then(build__templates);
}


/**
 * {private} Get meta.toml data
 */
function getMeta() {
  const content = fs.readFileSync(join(root, 'src/meta.toml'), 'utf-8');
  return toml.parse(content);
}


/**
 * {private} Collect additional data
 */
function collectAdditionalData(assetFiles) {
  const meta = getMeta();
  const assets = {};

  assetFiles.forEach((f) => {
    assets[`${f.basename}${f.extname}`] = f;
  });

  return { ...meta, assets };
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
    [frontmatter, { lang: 'toml' }, { toml }],
    [metadata, data],
    [pathToRoot],
    [layouts],
    [evilIcons],
    [templates, render],
    [renameExtension, '.html'],
    [permalinks],
    [write, 'build']
  )(
    'src/templates/**/*.mu',
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
