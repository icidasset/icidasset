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


  <!-- NOW -->
  <div class="block">
    <h2 class="block__title">What I'm doing now</h2>

    <div class="block__text">
      <p>
        I’m currently taking up Elixir and functional programming.
        Experimenting with static websites and webpack.
        Traveling to Canada for the first time.
        Trying to stick to <a href="https://www.evernote.com/shard/s268/sh/0b02360f-1455-4889-b898-d87c60dba15c/6d72d9048cfdf443a8360f158b79e665">this workout schedule</a>.
        Reading `Meditations, by Marcus Aurelius`.
      </p>
    </div>

    <div class="block__text block__text--subtle">
      <p><em>Last update, march 2016.</em></p>
    </div>
  </div>


  <!-- PROJECTS -->
  <div class="block">
    <h2 class="block__title">Latest projects</h2>

    <div class="block__list">
      <ul>
        {{#each projects}}
          <li><a href="{{url}}">{{name}}</a></li>
        {{/each}}
      </ul>
    </div>
  </div>


  <!-- WRITINGS -->
  <div class="block">
    <h2 class="block__title">Latest writings</h2>

    <div class="block__list">
      <ul>
        {{#each collections.latestWritings}}
          <li><a href="{{@root.pathToRoot}}writings/{{path}}">{{metadata.title}}</a></li>
        {{/each}}
      </ul>
    </div>

    <div class="block__text block__text--subtle">
      <p>
        <a href="{{@root.pathToRoot}}writings/">
          <em>{{{icon "ei-eye"}}} See all</em>
        </a>
      </p>
    </div>
  </div>


  <!-- LINKS -->
  <div class="block">
    <h2 class="block__title">Links</h2>

    <div class="block__list">
      <ul class="links">
        {{#each links}}
          <li>
            <a href="{{url}}">{{name}}</a>
          </li>
        {{/each}}
      </ul>
    </div>
  </div>

</div>
