import { resolve } from 'path';
import handlebars from 'handlebars';

import { run } from 'static-base';
import { read } from 'static-base-contrib';


const root = resolve(__dirname, '../../');


export default function(path) {
  return run(read)(path, root).then((files) => {
    Object.keys(handlebars.partials).forEach((key) => {
      handlebars.unregisterPartial(key);
    });

    files.forEach((f) => {
      const key = f.path.replace(new RegExp(`${f.extname}$`), '');
      handlebars.registerPartial(key, f.content);
    });

    return files;
  });
}
