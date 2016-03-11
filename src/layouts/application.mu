<html>
<head>
  <meta charset="utf-8" />

  <title>
    {{#if title}}{{title}} &ndash; {{/if}}I.A.
  </title>

  <link rel="stylesheet" href="{{ pathToRoot }}{{ assets.[main.css].path }}" />
  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Libre+Baskerville:400,700,400italic|Montserrat:700,400" />

  {{> favicons}}
</head>
<body>


  {{> header}}

  {{{ content }}}
  {{{ evilIcons.sprite }}}


  <script src="{{ pathToRoot }}{{ assets.[main.js].path }}"></script>


</body>
</html>
