import { join, resolve } from 'path';
import chalk from 'chalk';
import express from 'express';


const BUILD_DIR = resolve(__dirname, '../../build');


export default function() {
  const app = express();

  app.use(express.static(BUILD_DIR));
  app.use(handleNotFound);

  app.listen(8080, callback);
}


function callback() {
  console.log(chalk.bold.magenta('Running static server at localhost:8080'));
}


function handleNotFound(req, res) {
  res.status(400).sendFile( join(BUILD_DIR, '404.html') );
}
