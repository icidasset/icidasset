import { join } from 'path';
import fs from 'fs';


export default function(data) {
  const content = fs.readFileSync(join(data.__root__, 'src/cached_data/quotes.json'), 'utf-8');
  return Promise.resolve({ ...data, quotes: JSON.parse(content) });
}
