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

    var toggles2 = [].slice.call(sideNavigation.querySelectorAll('a.p-side-navigation__link'));
    toggles2.forEach(function (toggle) {
        toggle.addEventListener('click', function (event) {
            var sideNav = document.getElementById("drawer");
            if (sideNav) {
                toggleDrawer(sideNav, false);
            }
        });
    });
}

function setupSideNavigations(sideNavigationSelector) {
    var sideNavigations = [].slice.call(document.querySelectorAll(sideNavigationSelector));

    sideNavigations.forEach(setupSideNavigation);
}

setupSideNavigations('.p-side-navigation, [class*="p-side-navigation--"]');