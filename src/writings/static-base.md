---
title = "Why I wrote static-base"
category = "Code"
published = true
promote = true
---

First of all, what is it anyway? It's a small functional toolset written for [node.js](https://nodejs.org/en/) to **build static websites**, and by that I mean, output html files. As it is still the fundamental part of the web, it's probably not a bad idea to consider it as a rather important piece of puzzle.

<small>_Links:_</small>  
[**static-base** github repo](https://github.com/icidasset/static-base)  
[**static-base-contrib** github repo](https://github.com/icidasset/static-base-contrib)  
[**static-base-preset** github repo](https://github.com/icidasset/static-base-preset)

I guess the most used, and easiest to understand, example would be a blog. You input text in a certain format, for example Markdown, and after the processing you get html. Let me explain it in more detail:

1. We write some text in Markdown.
2. We need a way of adding some "easy extractable" metadata, so we use a format like [front-matter](https://jekyllrb.com/docs/frontmatter/). Here we define, for example, the title and category.
3. We need a layout, where we set the document title.
4. We get a html page we can publish.

Ok so, how do we go about this? Let's define this in more concrete steps.

1. **Select** the markdown files.
2. **Read** the contents of those files.
3. **Extract** the front-matter and store that data "in memory".
4. **Convert** the markdown to html.
5. **Wrap** the converted markdown (ie. the html) in a html template/layout.
6. **Change** the file extension to `.html`.
7. **Write** that html to disk.

Those are the 7 actions we need to _run_ on our input, to get our output.
Here I thought, hey, it sounds like **every action is a function**...


## Functional programming

Functional programming taught me to write functions without side effects, so we can easily see what a function does and not worry about it too much. For our use case, every action should clearly define what its intentions are and do nothing else. Because we can easily deduce what our functions do, we can combine those in a sequence (ie. compose). For example, given our previous markdown example:

> Select, read, extract, convert, wrap, change and write.

That would be our markdown sequence.


## Where did the idea come from?

The idea originated from [metalsmith](http://www.metalsmith.io/), which works like this:

> 1 – Read all the files in a source directory.  
> 2 – Invoke a series of plugins that manipulate the files.  
> 3 – Write the results to a destination directory!

_Source: [the metalsmith website](http://www.metalsmith.io/)_

The thing that I liked very much about this, is that **you express what you want to do**. But I wanted even more control over what happens. That said, here's what static-base does differently:

- Does not read files by default
- Does not write files by default
- Does not make any assumptions about your file structure
- Does not have a cli
- Supports promises
- Supports combinations (ie. you can input the result of one sequence into a new sequence)
- Metadata and front-matter are not part of the core library


## How does it work?

Now that we explain the **why**, let's explain the **how**. I'll continue with the previous markdown example. I'll also use a library called `static-base-contrib`, which has some predefined functions, like `read` and `write`.

```js
import { run } from 'static-base';
import { frontmatter, read, renameExt, write } from 'static-base-contrib';
import { markdown } from 'markdown';
import Mustache from 'mustache';


/**
 * Params
 *
 * 1. the glob pattern to select our markdown files
 * 2. the path to the directory in which our posts live
 */
const fileSelector = 'input/posts/*.md';
const rootDirectoryPath = __dirname;


/**
 * Aliases
 *
 * To better explain our example.
 */
const extract = frontmatter;
const change = renameExt;


/**
 * Markdown parser
 */
function convert(files) {
  // return new files array
  return files.map(function(file) {
    // make a copy of the file object,
    // and put the parsed markdown in it
    return {
      ...file,
      content: markdown.toHTML(file.content),
    };
  });
}


/**
 * Wrap function
 *
 * Uses Mustache as the template syntax.
 */
const layout = `
<!DOCTYPE html>
<html>
  <head><title>{{title}}</title></head>
  <body><h1>{{title}}</h1>{{{content}}}</body>
</html>
`.trim();

function wrap(files) {
  // return new files array
  return files.map(function(file) {
    // make a copy of the file object,
    // and put the rendered layout template in it
    return {
      ...file,
      content: Mustache.render(layout, file),
    };
  });
}


/**
 * Run the sequence (ie. build)
 */
run(
  read,
  extract,
  convert,
  wrap,
  [change, '.html'],  // change the extension of the file
  [write, 'output']   // write the file to the 'output' directory
)(
  fileSelector,
  rootDirectoryPath
).then(function() {
  console.log('BUILD SUCCEEDED :D');
}, function(error) {
  console.error('BUILD FAILED :(');
  console.error(error);
});
```

This is all the code you need to build the markdown example.
See the entire example [here](https://github.com/icidasset/static-base-markdown-example).


## Feedback

What did you think? Feel free to send me some feedback on [Twitter](https://twitter.com/icidasset) or wherever else you can find me.
