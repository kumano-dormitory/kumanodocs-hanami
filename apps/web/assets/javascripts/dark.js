function setDark() {
  document.documentElement.classList.add('is-dark');
  document.body.classList.add('is-dark');

  var header = document.getElementById('navigation');
  if (header) { header.classList.add('is-dark'); }
  var topimg = document.getElementById('top-img');
  if (topimg) {
    topimg.src = "/assets/abstruct-dark.svg";
  }
  var forms = document.getElementsByTagName('form');
  for (var i = 0; i < forms.length; i++) {
    forms[i].classList.add('is-dark');
  }
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
  var forms = document.getElementsByTagName('form');
  for (var i = 0; i < forms.length; i++) {
    forms[i].classList.remove('is-dark');
  }
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
