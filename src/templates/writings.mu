---
title = "Writings"
---

<div class="container">

  <div class="blocks">
    <div class="blocks__row has-no-margin-top">

      <div class="block">
        <h1 class="block__title">{{title}}</h1>

        <div class="block__list">
          <ul>
            {{#each collections.writings}}
              {{#if metadata.published}}
                <li><a href="{{@root.pathToRoot}}writings/{{path}}">{{metadata.title}}</a></li>
              {{/if}}
            {{/each}}
          </ul>
        </div>

        <div class="block__text block__text--subtle">
          <p><em>Ordered by name.</em></p>
        </div>
      </div>


      <a class="block block--filler has-content" hide-lt="small">
        <span class="block--filler__inner">
          {{{icon 'i-text-document'}}}
          <span>{{title}}</span>
        </span>
      </a>

    </div>
  </div>

</div>
