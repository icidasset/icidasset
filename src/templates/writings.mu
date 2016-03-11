---
title = "Writings"
---

<div class="container">

  <h1>{{title}}</h1>

  <div class="block block--without-margin">
    <div class="block__list">
      <ul>
        {{#each collections.writings}}
          <li><a href="{{pathToRoot}}writings/{{path}}">{{metadata.title}}</a></li>
        {{/each}}
      </ul>
    </div>

    <div class="block__text block__text--subtle">
      <p><em>Ordered by date.</em></p>
    </div>
  </div>

</div>
