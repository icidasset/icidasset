import handlebars from 'handlebars';

import partials from './partials';


export default function(template, data) {
  return partials('src/partials/**/*.mu').then(() => {
    return handlebars.compile(template)(data);
  });
}
