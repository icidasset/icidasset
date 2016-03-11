import chalk from 'chalk';

import build from './tasks/build';
import server from './tasks/server';
import watch from './tasks/watch';

import './handlebars/helpers';


const make = () => {
  return build().then(
    () => console.log(chalk.bold.green('Build successful!'))
  );
};


make()
  .then(() => watch(make))
  .then(() => server())
  .catch((err) => console.log(chalk.bold.red(err)));
