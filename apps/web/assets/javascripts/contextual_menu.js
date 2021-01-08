function toggleDrawer(sideNavigation, show) {
  if (sideNavigation) {
    if (show) {
      sideNavigation.classList.remove('is-collapsed');
      sideNavigation.classList.add('is-expanded');
    } else {
      sideNavigation.classList.remove('is-expanded');
      sideNavigation.classList.add('is-collapsed');
    }
  }
}

function setupSideNavigation(sideNavigation) {
  var toggles = [].slice.call(sideNavigation.querySelectorAll('.js-drawer-toggle'));

  toggles.forEach(function (toggle) {
    toggle.addEventListener('click', function (event) {
      event.preventDefault();
      var sideNav = document.getElementById(toggle.getAttribute('aria-controls'));

      if (sideNav) {
        toggleDrawer(sideNav, !sideNav.classList.contains('is-expanded'));
      }
    });
  });
}

function setupSideNavigations(sideNavigationSelector) {
  var sideNavigations = [].slice.call(document.querySelectorAll(sideNavigationSelector));

  sideNavigations.forEach(setupSideNavigation);
}

setupSideNavigations('.p-side-navigation, [class*="p-side-navigation--"]');

function setupTopDrawerListeners(sideNavigationToggleSelector) {
  const toggles = document.querySelectorAll(sideNavigationToggleSelector);

  toggles.forEach(toggle => {
    toggle.addEventListener('click', e => {
      e.preventDefault();
      var sideNav = document.getElementById(toggle.getAttribute('aria-controls'));

      if (sideNav) {
        toggleDrawer(sideNav, !sideNav.classList.contains('is-expanded'));
      }
    });
  });
}

setupTopDrawerListeners('#side-navigation-top-drawer');