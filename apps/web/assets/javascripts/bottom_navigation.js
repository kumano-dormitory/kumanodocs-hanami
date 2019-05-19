const bn_bl = document.getElementById('bottom-navigation-bl');
const bn_home = document.getElementById('bottom-navigation-home');
const bn_search = document.getElementById('bottom-navigation-search');

function setClassName(el, active) {
  if (el.children.length == 2) {
    if (active) {
      el.children[0].className = "bottom-navigation-icon__active"
      el.children[1].className = "bottom-navigation-label__active"
    } else {
      el.children[0].className = "bottom-navigation-icon"
      el.children[1].className = "bottom-navigation-label"
    }
  }
}

bn_bl.addEventListener('click', event => {
  if (location.pathname === '/meeting') {
    window.scrollTo(0, 0);
  } else {
    window.location.href = '/meeting';
  }
  setClassName(bn_bl, true);
  setClassName(bn_home, false);
  setClassName(bn_search, false);
});

bn_home.addEventListener('click', event => {
  if (location.pathname === '/') {
    window.scrollTo(0, 0);
  } else {
    window.location.href = '/';
  }
  setClassName(bn_bl, false);
  setClassName(bn_home, true);
  setClassName(bn_search, false);
});

bn_search.addEventListener('click', event => {
  var reg = new RegExp(/^\/article\/search.*/);
  if (reg.test(location.pathname)) {
    window.scrollTo(0, 0);
  } else {
    window.location.href = '/article/search';
  }
  setClassName(bn_bl, false);
  setClassName(bn_home, false);
  setClassName(bn_search, true);
});
