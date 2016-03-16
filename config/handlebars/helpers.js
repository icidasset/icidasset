import handlebars from 'handlebars';


handlebars.registerHelper('icon', function(name) {
  const classes = `icon icon--${name}`;
  const path = `${this.pathToRoot}images/icons.svg`;
  const icon = `<svg class="icon__cnt"><use xlink:href="${path}#${name}" /></svg>`;
  const span = `<span class="${classes}">${icon}</span>`;

  return span;
});
