import matter from 'gray-matter';
import toml from 'toml';


matter.parsers.requires.toml = toml;


export default function(files) {
  return files.map((f) => {
    const m = matter(f.content, { lang: 'toml' });

    return {
      ...f,
      ...m.data,

      content: m.content,
    };
  });
}
