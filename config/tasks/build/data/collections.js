import { run } from 'static-base';
import { frontmatter, permalinks, pathToRoot, read, renameExtension } from 'static-base-contrib';
import toml from 'toml';


export default function(data) {
  return Promise.resolve(data).then(writings);
}


/*

Collections is a object that contains collections of files.
Sequence: read, frontmatter, renameToHTML, permalinks, pathToRoot.

{
  writings: Dictionary
}

*/


function writings(data) {
  return run(
    [read],
    [frontmatter, { lang: 'toml' }, { toml }],

    [renameExtension, '.html'],
    [permalinks],
    [pathToRoot],
  )(
    'src/writings/**/*.md',
    data.__root__
  ).then((files) => {
    const writings = [...files];

    return {
      ...data,

      collections: {
        ...data.collections,

        writings,
      },
    }
  });
}
