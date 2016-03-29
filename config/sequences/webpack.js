import { run } from 'static-base';
import { webpack, write } from 'static-base-contrib';

import webpackConfig from '../webpack';


export default function(data) {
  return run(
    [webpack, webpackConfig],
    [write, 'build']
  )();
}
