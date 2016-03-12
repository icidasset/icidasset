import it from 'markdown-it';

import it__anchor from 'markdown-it-anchor';
import it__footnote from 'markdown-it-footnote';
import it__mark from 'markdown-it-mark';
import it__sub from 'markdown-it-sub';
import it__sup from 'markdown-it-sup';

import { escapeHtml } from 'markdown-it/lib/common/utils';

import Prism from 'prismjs/components/prism-core.js';

import 'prismjs/components/prism-clike.js';
import 'prismjs/components/prism-markup.js';

import 'prismjs/components/prism-bash.js';
import 'prismjs/components/prism-c.js';
import 'prismjs/components/prism-css.js';
import 'prismjs/components/prism-diff.js';
import 'prismjs/components/prism-docker.js';
import 'prismjs/components/prism-elixir.js';
import 'prismjs/components/prism-erlang.js';
import 'prismjs/components/prism-git.js';
import 'prismjs/components/prism-go.js';
import 'prismjs/components/prism-handlebars.js';
import 'prismjs/components/prism-haskell.js';
import 'prismjs/components/prism-http.js';
import 'prismjs/components/prism-javascript.js';
import 'prismjs/components/prism-json.js';
import 'prismjs/components/prism-makefile.js';
import 'prismjs/components/prism-markdown.js';
import 'prismjs/components/prism-ruby.js';
import 'prismjs/components/prism-rust.js';
import 'prismjs/components/prism-sql.js';
import 'prismjs/components/prism-swift.js';
import 'prismjs/components/prism-yaml.js';


const md = it({ highlight, html: true });


md.use(it__anchor);
md.use(it__footnote);
md.use(it__mark);
md.use(it__sub);
md.use(it__sup);


md.renderer.rules.code_inline = (tokens, idx) => {
  return  '<code class="language-unknown">' +
            escapeHtml(tokens[idx].content) +
          '</code>';
};


export default function(files, deps) {
  return files.map((f) => {
    return {
      ...f,

      content: md.render(f.content),
    };
  });
}


function highlight(str, lang) {
  const html = Prism.highlight(str, Prism.languages[lang], lang);
  return `<pre class="language-${lang}">${html}</pre>`;
}
