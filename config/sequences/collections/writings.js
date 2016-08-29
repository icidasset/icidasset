import { run } from 'static-base';
import layouts from '../../base/layouts';
import markdown from '../../base/markdown';
import toml from 'toml';

import {
  frontmatter,
  metadata,
  parentPath,
  pathToRoot,
  permalinks,
  read,
  renameExt,
} from 'static-base-contrib';


export default function(data) {
  return run(
    [read],
    [layouts, ['src/layouts/writing.mu', 'src/layouts/application.mu']],
    [renameExt, '.html'],
    [permalinks],
    [pathToRoot, 1],
    [parentPath],
    [frontmatter, { parser: toml.parse, lang: 'toml' }],
    [metadata, { ...data, collection: 'writings' }],
    [markdown]
  )(
    'src/writings/**/*.md',
    data.__root__
  );
}
