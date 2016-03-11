import evilIcons from 'evil-icons';
import handlebars from 'handlebars';


handlebars.registerHelper('icon', (name) => {
  const classes = `icon icon--${name}`;
  const icon = `<svg class="icon__cnt"><use xlink:href="#${name}-icon" /></svg>`;
  const span = `<span class="${classes}">${wrapSpinner(icon, classes)}</span>`;

  return span;
});


function wrapSpinner(html, classes) {
  if (classes.includes('spinner')) {
    return `<span class="icon__spinner">${html}</span>`;
  }

  return html;
}
