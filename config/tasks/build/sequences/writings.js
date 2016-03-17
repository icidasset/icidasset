import { run } from 'static-base';
import { metadata, pathToRoot, permalinks } from 'static-base-contrib';
import { read, renameExtension, templates, write } from 'static-base-contrib';

import layouts from '../../../base/layouts';
import markdown from '../../../base/markdown';
import parentPath from '../../../base/parent-path';
import render from '../../../handlebars/render';


export default function(data) {
  return run(
    [() => data.collections.writings],

    [metadata, { ...data, collection: 'writings' }],
    [layouts, ['src/layouts/writing.mu', 'src/layouts/application.mu']],
    [markdown],
    [renameExtension, '.html'],
    [permalinks],
    [pathToRoot, 1],
    [parentPath],
    [templates, render],
    [write, 'build/writings']
  )(
    null,
    data.__root__,
  );
}
