import anim from 'anim';
import delegate from 'delegate';


/*

  node: <h2 />

  - Should add the ability to click on a <h2> node with an id
    and change the hash in the location to that id.

*/


export function initialize() {
  delegate(document.body, 'h2[id]', 'click', h2id__click, true);
}


function h2id__click(event) {
  const hash = `#${event.delegateTarget.id}`;

  if (history.pushState) window.history.pushState(null, null, hash);
  else window.location.hash = hash;

  anim(
    document.body,
    'scrollTop',
    window.scrollY + event.delegateTarget.getBoundingClientRect().top - 24,
    { duration: 750, ease: 'inOutExpo' }
  );
}
