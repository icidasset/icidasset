import { run } from 'static-base';
import { metadata, parentPath, pathToRoot, permalinks } from 'static-base-contrib';
import { read, renameExtension } from 'static-base-contrib';
import applyFilter from 'static-base-contrib/lib/utils/filter';
import toml from 'toml';

import frontmatter from '../../base/frontmatter';
import layouts from '../../base/layouts';


export default function(data) {
  return run(
    [read],
    [layouts],
    [renameExtension, '.html'],
    [applyFilter(permalinks, permalinksFilter)],
    [pathToRoot],
    [parentPath],
    [frontmatter],
    [metadata, data]
  )(
    'src/templates/**/*.mu',
    data.__root__,
  );
}


function permalinksFilter(file) {
  return ['404'].includes(file.basename) === false;
}
