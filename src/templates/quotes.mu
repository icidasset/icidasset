---
title = "Quotes I Like"
---

<div class="container">

  <div class="blocks">
    <div class="blocks__row has-no-margin-top">

      <div class="block">
        <h1 class="block__title">{{title}}</h1>

        <div class="block__list">
          <ul>
            {{#each quotes}}
              <li>
                <blockquote>
                  <p>
                    {{quote}}
                  </p>
                </blockquote>

                <p>
                  <small>&mdash;&nbsp; {{author}}</small>
                </p>
              </li>
            {{/each}}
          </ul>
        </div>

        <div class="block__text block__text--subtle">
          <p><em>Ordered by author.</em></p>
        </div>
      </div>


      <a class="block block--filler" hide-lt="small">
        <span class="block--filler__inner">
          {{{icon 'i-quote'}}}
          <span>{{title}}</span>
        </span>
      </a>

    </div>
  </div>

</div>
