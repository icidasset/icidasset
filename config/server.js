import chalk from 'chalk';
import express from 'express';


export default function() {
  const app = express();
  const port = 8080;

  app.use(express.static('../build'));

  app.listen(port, () => {
    console.log(chalk.bold.magenta('Running static server at localhost:8080'));
  });
}
