---
title = "Projects"
---

<div class="container">

  <div class="blocks">
    <div class="blocks__row has-no-margin-top">

      <div class="block">
        <h1 class="block__title">{{title}}</h1>

        <div class="block__list has-extra-space">
          <ul>
            {{#each projects}}
              <li>
                <a href="{{url}}">
                  {{name}}
                </a>
                <br />
                <small class="small--block">{{description}}</small>
              </li>
            {{/each}}
          </ul>
        </div>

        <div class="block__text block__text--subtle">
          <p><em>Ordered by name.</em></p>
        </div>
      </div>


      <a class="block block--filler" hide-lt="small">
        <span class="block--filler__inner">
          {{{icon 'i-tools'}}}
          <span>{{title}}</span>
        </span>
      </a>

    </div>
  </div>

</div>
