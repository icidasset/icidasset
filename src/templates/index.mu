<div class="container">

  <p class="intro">
    I’m a programmer living in Ghent, Belgium,
    who works for a company based in Victoria, Canada,
    named <a href="http://metalab.co/">MetaLab</a>. I love great music, books and quotes.
    I also dabble in electrical engineering.
  </p>


  <!-- NOW -->
  <div class="block">
    <h2 class="block__title">What I'm doing now</h2>

    <div class="block__text">
      <p>
        I’m currently taking up Elixir and functional programming.
        Experimenting with static websites and webpack.
        Traveling to Canada for the first time.
        Trying to stick to this workout schedule.
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
