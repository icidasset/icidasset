import { join } from 'path';
import { cleanPath } from 'static-base/lib/utils';


export default function(files, deps) {
  return files.map((f) => {
    const dirs = f.dirname.length ? f.dirname.split('/') : [];
    const parent = dirs.map(d => '..').join('/');

    if (parent.length) return { ...f, parentPath: `${parent}/` };
    return f;
  });
}
