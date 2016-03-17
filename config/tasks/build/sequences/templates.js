import { run } from 'static-base';
import { frontmatter, metadata, pathToRoot, permalinks } from 'static-base-contrib';
import { read, renameExtension, templates, write } from 'static-base-contrib';
import toml from 'toml';

import layouts from '../../../base/layouts';
import parentPath from '../../../base/parent-path';
import render from '../../../handlebars/render';


export default function(data) {
  run(
    [read],
    [frontmatter, { lang: 'toml' }, { toml }],
    [metadata, data],
    [layouts],
    [renameExtension, '.html'],
    [permalinks],
    [pathToRoot],
    [parentPath],
    [templates, render],
    [write, 'build']
  )(
    'src/templates/**/*.mu',
    data.__root__,
  );

  return data;
}
