<div class="container">

  <p class="intro">
    I’m a programmer living in Ghent, Belgium,
    who works for a company based in Victoria, Canada,
    named <a href="http://metalab.co/">MetaLab</a>.
    I love great <a href="https://soundcloud.com/purplesynth/likes">music</a>,
    <a href="https://www.goodreads.com/user/show/12152181-steven">books</a> and
    <a href="http://keymaps-api.herokuapp.com/public/MS9xdW90ZXM=">quotes</a>.
    I also dabble in <a href="https://electrical-mathematics.surge.sh/">electrical engineering</a>.
  </p>



  <div class="blocks">


    <div class="blocks__row">
      <a href="{{pathToRoot}}writings/" class="block block--filler with-content">
        <span class="block--filler__inner">
          {{{icon 'ei-pencil'}}}
          <span>See all writings</span>
        </span>
      </a>

      {{> blocks/now}}
    </div>

    <div class="blocks__row">
      {{> blocks/latest-writings}}
      {{> blocks/filler}}
    </div>

    <div class="blocks__row">
      <a href="{{pathToRoot}}projects/" class="block block--filler with-content">
        <span class="block--filler__inner">
          {{{icon 'ei-archive'}}}
          <span>See all projects</span>
        </span>
      </a>

      {{> blocks/latest-projects}}
    </div>

    <div class="blocks__row">
      {{> blocks/social}}
      {{> blocks/filler}}
    </div>

  </div>
</div>
