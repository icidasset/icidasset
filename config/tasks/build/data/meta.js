import { join } from 'path';
import fs from 'fs';
import toml from 'toml';


export default function(data) {
  const content = fs.readFileSync(join(data.__root__, 'src/meta.toml'), 'utf-8');
  return Promise.resolve({ ...data, ...toml.parse(content) });
}
