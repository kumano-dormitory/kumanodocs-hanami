function toggleMenu(element, show) {
  element.setAttribute('aria-expanded', show);
  document
    .querySelector(element.getAttribute('aria-controls'))
    .setAttribute('aria-hidden', !show);
}

function setupContextualMenuListeners(contextualMenuToggleSelector) {
  const toggles = document.querySelectorAll(contextualMenuToggleSelector);

  toggles.forEach(toggle => {
    toggle.addEventListener('click', e => {
      e.preventDefault();

      const target = e.target;
      const menuAlreadyOpen = target.getAttribute('aria-expanded') === 'true';

      toggleMenu(target, !menuAlreadyOpen)
    });
  });

  document.addEventListener('click', e => {
    toggles.forEach(toggle => {
      const contextualMenu = document.querySelector(toggle.getAttribute('aria-controls'));
      const clickOutside = !(toggle.contains(e.target) || contextualMenu.contains(e.target));

      if (clickOutside) {
        toggleMenu(toggle, false);
      }
    })
  });

  document.onkeydown = e => {
    e = e || window.event;

    if (e.keyCode === 27) {
      toggles.forEach(toggle => {
        toggleMenu(toggle, false);
      });
    }
  };
}

setupContextualMenuListeners('.p-contextual-menu__toggle');
