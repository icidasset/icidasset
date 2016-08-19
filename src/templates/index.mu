<div class="container">

  <p class="intro">
    I’m a programmer living in Ghent, Belgium,
    who works for a company based in Victoria, Canada,
    named <a href="http://metalab.co/">MetaLab</a>.
    I love great <a href="https://soundcloud.com/purplesynth/likes">music</a>,
    <a href="{{pathToRoot}}books/">books</a> and
    <a href="{{pathToRoot}}quotes/">quotes</a>.
    I also dabble in <a href="https://electrical-mathematics.surge.sh/">electrical engineering</a>.
  </p>



  <div class="blocks">

    <div class="blocks__row">
      {{> blocks/now}}
      {{> blocks/social}}
    </div>


    <div class="blocks__row">
      {{> blocks/latest-projects}}
      {{> blocks/latest-writings}}
    </div>


    <div class="blocks__row">
      <a href="{{pathToRoot}}projects/" class="block block--filler has-content has-fixed-height">
        <span class="block--filler__inner">
          {{{icon 'i-tools'}}}
          <span>See all projects</span>
        </span>
      </a>

      <a href="{{pathToRoot}}writings/" class="block block--filler has-content has-fixed-height">
        <span class="block--filler__inner">
          {{{icon 'i-text-document'}}}
          <span>See all writings</span>
        </span>
      </a>
    </div>

  </div>
</div>
