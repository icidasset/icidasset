import it from 'markdown-it';

import it__anchor from 'markdown-it-anchor';
import it__footnote from 'markdown-it-footnote';
import it__mark from 'markdown-it-mark';
import it__sub from 'markdown-it-sub';
import it__sup from 'markdown-it-sup';


const md = it({ html: true });


md.use(it__anchor);
md.use(it__footnote);
md.use(it__mark);
md.use(it__sub);
md.use(it__sup);


export default function(files, deps) {
  return files.map((f) => {
    return {
      ...f,

      content: md.render(f.content),
    };
  });
}
