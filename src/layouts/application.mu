<html>
<head>
  <meta charset="utf-8" />

  <title>
    {{#if title}}{{title}} &ndash; {{/if}}I.A.
  </title>

  <link rel="stylesheet" href="{{ pathToRoot }}{{ assets.[main.css].path }}" />
</head>
<body>


  {{> header}}

  {{{ content }}}
  {{{ evilIcons.sprite }}}


  <script src="{{ pathToRoot }}{{ assets.[main.js].path }}"></script>


</body>
</html>
