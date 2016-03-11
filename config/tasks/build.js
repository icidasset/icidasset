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
import markdown from '../base/markdown';


const root = resolve(__dirname, '../../');


export default function() {
  return build__webpack()
    .then(makeDataObject)
    .then(makeWritingsCollection)
    .then(build__templates)
    .then(build__writings)
    .then(build__staticAssets);
}


/**
 * {private} meta.toml
 */
function getMeta() {
  const content = fs.readFileSync(join(root, 'src/meta.toml'), 'utf-8');
  return toml.parse(content);
}


/**
 * {private} Additional data
 */
function makeDataObject(assetFiles) {
  const meta = getMeta();
  const assets = {};

  assetFiles.forEach((f) => {
    assets[`${f.basename}${f.extname}`] = f;
  });

  return { ...meta, assets };
}


function makeWritingsCollection(data) {
  return run(
    [list__writings],

    [renameExtension, '.html'],
    [permalinks],
    [pathToRoot],
  )(
    null,
    root
  ).then((files) => {
    const writings = [...files];

    return {
      ...data,

      collections: {
        ...data.collections,

        writings,
        latestWritings: writings.slice(0, 5),
      },
    }
  });
}


/**
 * {private} Webpack
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
 * {private} Templates
 */
function build__templates(data) {
  run(
    [read],
    [frontmatter, { lang: 'toml' }, { toml }],
    [metadata, data],
    [layouts],
    [evilIcons],
    [renameExtension, '.html'],
    [permalinks],
    [pathToRoot],
    [templates, render],
    [write, 'build']
  )(
    'src/templates/**/*.mu',
    root,
  );

  return data;
}


/**
 * {private} Writings
 */
const writings = 'src/writings/**/*.md';


function list__writings() {
  return run(
    [read],
    [frontmatter, { lang: 'toml' }, { toml }],
  )(
    writings,
    root,
  );
}


function build__writings(data) {
  return run(
    [() => data.collections.writings],

    [metadata, data],
    [layouts, ['src/layouts/writing.mu', 'src/layouts/application.mu']],
    [evilIcons],
    [markdown],
    [renameExtension, '.html'],
    [permalinks],
    [pathToRoot, 1],
    [templates, render],
    [write, 'build/writings']
  )(
    null,
    root,
  );
}


/**
 * {private} Static assets
 */
function build__staticAssets() {
  return run(
    [copy, 'build/images']
  )(
    'src/images/**/*',
    root
  );
}
