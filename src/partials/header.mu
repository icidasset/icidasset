<header class="header">
  <div class="container">

    <div class="header__col header__col--left">
      <a href="{{pathToRoot}}" class="header__logo">I.A.</a>

      {{#if parentPath}}
        <a href="{{parentPath}}" class="header__go-up" title="Go up">
          {{{icon 'i-aircraft-take-off'}}}
        </a>
      {{/if}}
    </div>

    <div class="header__col header__col--right">
      <span>Steven Vandevelde</span>
    </div>

  </div>
</header>
