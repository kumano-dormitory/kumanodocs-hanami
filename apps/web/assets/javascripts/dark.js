function setDark() {
  document.documentElement.classList.add('is-dark');
  document.body.classList.add('is-dark');

  var header = document.getElementById('navigation');
  if (header) { header.classList.add('is-dark'); }
  var topimg = document.getElementById('top-img');
  if (topimg) {
    topimg.src = "/assets/abstruct-dark.svg";
  }
  var side_navs = document.getElementsByClassName('p-side-navigation');
  for (var i = 0; i < side_navs.length; i++) { side_navs[i].classList.add('is-dark'); }
  var buttons = document.getElementsByClassName('p-button');
  for (var i = 0; i < buttons.length; i++) { buttons[i].classList.add('is-dark'); }
  var buttons_base = document.getElementsByClassName('p-button--base');
  for (var i = 0; i < buttons_base.length; i++) { buttons_base[i].classList.add('is-dark'); }
  var buttons_positive = document.getElementsByClassName('p-button--positive');
  for (var i = 0; i < buttons_positive.length; i++) { buttons_positive[i].classList.add('is-dark'); }
  var buttons_negative =  document.getElementsByClassName('p-button--positive');
  for (var i = 0; i < buttons_negative.length; i++) { buttons_negative[i].classList.add('is-dark'); }
  var buttons_brand =  document.getElementsByClassName('p-button--brand');
  for (var i = 0; i < buttons_brand.length; i++) { buttons_brand[i].classList.add('is-dark'); }
  var dividers = document.getElementsByClassName('p-divider');
  for (var i = 0; i < dividers.length; i++) {
    dividers[i].classList.add('is-dark');
  }
  var middot_lists = document.getElementsByClassName('p-inline-list--middot');
  for(var i = 0; i < middot_lists.length; i++) { middot_lists[i].classList.add('is-dark'); }
  var forms = document.getElementsByTagName('form');
  for (var i = 0; i < forms.length; i++) {
    forms[i].classList.add('is-dark');
  }
  var hrs = document.getElementsByTagName('hr');
  for (var i = 0; i < hrs.length; i++) { hrs[i].classList.add('is-dark'); }
}

function setLight() {
  document.documentElement.classList.remove('is-dark');
  document.body.classList.remove('is-dark');
  var header = document.getElementById('navigation');
  if (header) { header.classList.remove('is-dark'); }
  var topimg = document.getElementById('top-img');
  if (topimg) {
    topimg.src = "/assets/abstruct.svg";
  }
  var side_navs = document.getElementsByClassName('p-side-navigation');
  for (var i = 0; i < side_navs.length; i++) { side_navs[i].classList.remove('is-dark'); }
  var buttons = document.getElementsByClassName('p-button');
  for (var i = 0; i < buttons.length; i++) { buttons[i].classList.remove('is-dark'); }
  var buttons_base = document.getElementsByClassName('p-button--base');
  for (var i = 0; i < buttons_base.length; i++) { buttons_base[i].classList.remove('is-dark'); }
  var buttons_positive = document.getElementsByClassName('p-button--positive');
  for (var i = 0; i < buttons_positive.length; i++) { buttons_positive[i].classList.remove('is-dark'); }
  var buttons_negative =  document.getElementsByClassName('p-button--positive');
  for (var i = 0; i < buttons_negative.length; i++) { buttons_negative[i].classList.remove('is-dark'); }
  var buttons_brand =  document.getElementsByClassName('p-button--brand');
  for (var i = 0; i < buttons_brand.length; i++) { buttons_brand[i].classList.remove('is-dark'); }
  var dividers = document.getElementsByClassName('p-divider');
  for (var i = 0; i < dividers.length; i++) {
    dividers[i].classList.remove('is-dark');
  }
  var middot_lists = document.getElementsByClassName('p-inline-list--middot');
  for(var i = 0; i < middot_lists.length; i++) { middot_lists[i].classList.remove('is-dark'); }
  var forms = document.getElementsByTagName('form');
  for (var i = 0; i < forms.length; i++) {
    forms[i].classList.remove('is-dark');
  }
  var hrs = document.getElementsByTagName('hr');
  for (var i = 0; i < hrs.length; i++) { hrs[i].classList.remove('is-dark'); }
}

function initialize() {
  const localTheme = localStorage.getItem('theme-mode');
  if (localTheme == 'dark') {
    setDark();
  }
  const button = document.getElementById("theme-mode-btn");
  if (button) {
    button.checked = (localTheme == 'dark');
    button.addEventListener('change', function(e) {
      if (e.target.checked) {
        localStorage.setItem('theme-mode','dark');
        setDark();
      } else {
        localStorage.setItem('theme-mode','light');
        setLight();
      }
    });
  }
}

initialize();
