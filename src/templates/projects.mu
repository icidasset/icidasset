---
title = "Projects"
---

<div class="container">

  <div class="blocks">
    <div class="blocks__row has-no-margin-top">

      <div class="block">
        <h1 class="block__title">{{title}}</h1>

        <div class="block__list">
          <ul>
            {{#each projects}}
              <li><a href="{{url}}">{{name}}</a></li>
            {{/each}}
          </ul>
        </div>

        <div class="block__text block__text--subtle">
          <p><em>Ordered by name.</em></p>
        </div>
      </div>


      <a class="block block--filler has-content">
        <span class="block--filler__inner">
          {{{icon 'i-tools'}}}
          <span>{{title}}</span>
        </span>
      </a>

    </div>
  </div>

</div>
