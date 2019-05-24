const bottom_navigation = document.getElementById('bottom-navigation');
const bn_back = document.getElementById('bottom-navigation-back');
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

const user_agent = navigator.userAgent;
if (user_agent.indexOf('iPhone') >= 0 || user_agent.indexOf('iPad') >= 0 || user_agent.indexOf('iPod') >= 0) {
  bn_back.style.display = 'flex';
  bn_back.addEventListener('click', event => {
    history.back();
  });
}

var isIPhoneX = ((window.devicePixelRatio === 3 && (window.screen.width === 375 || window.screen.height === 375 || window.screen.width === 414 || window.screen.width === 414)) ||
  (window.devicePixelRatio === 2 && (window.screen.width === 414 || window.screen.height === 414)) ) &&
  /iPhone/.test(window.navigator.userAgent);
if (isIPhoneX) {
  bottom_navigation.style.height = '90px';
  bottom_navigation.style.paddingBottom = '34px';
}
