import chalk from 'chalk';

import build from './build';
import server from './server';
import watch from './watch';


const make = () => {
  return build().then(
    () => console.log(chalk.bold.green('Build successful!'))
  );
};


make()
  .then(() => watch(make))
  .then(() => server())
  .catch((err) => console.log(chalk.bold.red(err)));
