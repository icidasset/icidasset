<html>
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1">

  <title>
    {{#if title}}{{title}} &ndash; {{/if}}I.A.
  </title>

  <link rel="stylesheet" href="{{ pathToRoot }}{{ assets.[main.css].path }}" />
  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Playfair+Display|Montserrat:400,700|Lora:400,700,400italic,700italic" />

  {{> favicons}}
</head>
<body data-collection="{{collection}}">


  {{> header}}

  {{{ content }}}

  <script src="{{ pathToRoot }}{{ assets.[main.js].path }}"></script>

  {{#if env.production}}
    {{> analytics}}
  {{/if}}


</body>
</html>
