---
title = "Projects"
---

<div class="container">

  <h1>{{title}}</h1>

  <div class="block">
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

</div>
