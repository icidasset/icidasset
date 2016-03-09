import { resolve } from 'path';
import chokidar from 'chokidar';


export default function(callback) {
  const pattern = 'src/**/*';
  const cwd = resolve(__dirname, '../');

  chokidar.watch(pattern, { cwd, ignoreInitial: true }).on('all', (event, path) => {
    console.log(`{watch:${event}}`, path);
    callback();
  });
}
