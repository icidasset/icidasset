import { join } from 'path';
import { cleanPath } from 'static-base/lib/utils';


export default function(files, deps, prefix = '') {
  const __prefix = cleanPath(prefix, { beginning: true });

  return files.map((f) => {
    const __f = { ...f };
    const dirs = join(__prefix, f.dirname).split('/');
    dirs.pop();

    __f.prefix = __prefix;

    const parent = dirs.map(d => '..').join('/');
    if (parent.length) return { ...__f, parentPath: `${parent}/` };
    return __f;
  });
}
