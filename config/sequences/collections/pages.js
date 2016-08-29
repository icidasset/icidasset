import { filter as applyFilter } from 'static-base-contrib/utils';
import { run } from 'static-base';
import layouts from '../../base/layouts';
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
    [layouts],
    [renameExt, '.html'],
    [applyFilter(permalinks, permalinksFilter)],
    [pathToRoot],
    [parentPath],
    [frontmatter, { parser: toml.parse, lang: 'toml' }],
    [metadata, data]
  )(
    'src/templates/**/*.mu',
    data.__root__
  );
}


function permalinksFilter(file) {
  return ['404'].includes(file.basename) === false;
}
