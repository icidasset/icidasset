import { run } from 'static-base';
import { metadata, parentPath, pathToRoot, permalinks } from 'static-base-contrib';
import { read, renameExt } from 'static-base-contrib';

import frontmatter from '../../base/frontmatter';
import layouts from '../../base/layouts';
import markdown from '../../base/markdown';


export default function(data) {
  return run(
    [read],
    [layouts, ['src/layouts/writing.mu', 'src/layouts/application.mu']],
    [renameExt, '.html'],
    [permalinks],
    [pathToRoot, 1],
    [parentPath],
    [frontmatter],
    [metadata, { ...data, collection: 'writings' }],
    [markdown]
  )(
    'src/writings/**/*.md',
    data.__root__,
  );
}
