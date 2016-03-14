<div class="block">
  <h2 class="block__title">Latest projects</h2>

  <div class="block__list">
    <ul>
      {{#each projects}}
        {{#if promote}}
          <li><a href="{{url}}">{{name}}</a></li>
        {{/if}}
      {{/each}}
    </ul>
  </div>

  <div class="block__text block__text--subtle">
    <p><em>Ordered by name.</em></p>
  </div>
</div>
