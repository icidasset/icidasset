import { join } from 'path';
import { cleanPath } from 'static-base/lib/utils';


export default function(files, deps, prefix = '') {
  const __prefix = cleanPath(prefix, { beginning: true });

  return files.map((f) => {
    const dirs = join(__prefix, f.dirname).split('/');
    dirs.pop();

    const parent = dirs.map(d => '..').join('/');
    if (parent.length) return { ...f, parentPath: `${parent}/` };
    return f;
  });
}
