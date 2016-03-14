<div class="block">
  <h2 class="block__title">Latest writings</h2>

  <div class="block__list">
    <ul>
      {{#each collections.writings}}
        {{#if metadata.published}}
          {{#if metadata.promote}}
            <li><a href="{{@root.pathToRoot}}writings/{{path}}">{{metadata.title}}</a></li>
          {{/if}}
        {{/if}}
      {{/each}}
    </ul>
  </div>

  <div class="block__text block__text--subtle">
    <p><em>Ordered by name.</em></p>
  </div>
</div>
