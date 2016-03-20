import 'svgxuse';

import * as nodes from './nodes';


document.addEventListener('DOMContentLoaded', () => {
  Object.keys(nodes)
    .map(k => nodes[k])
    .filter(n => n && n.initialize)
    .forEach(n => n.initialize());
});
