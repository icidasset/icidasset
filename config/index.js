import chalk from 'chalk';

import build from './tasks/build';
import server from './tasks/server';
import watch from './tasks/watch';

import './handlebars/helpers';


const args = {
  serve: process.argv.includes('--serve'),
  watch: process.argv.includes('--watch'),
};


const make = () => {
  return build().then(
    () => console.log(chalk.bold.green('Build successful!'))
  );
};


let f = make();

if (args.watch) f = f.then(() => watch(make));
if (args.serve) f = f.then(() => server());

f.catch((err) => console.log(chalk.bold.red(err)));
