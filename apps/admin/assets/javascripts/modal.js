const toggles = document.querySelectorAll('.p-modal__open-close');

toggles.forEach(toggle => {
  toggle.addEventListener('click', e => {
    e.preventDefault();
    showModal('modal')
  });
});

const toggle = document.getElementById('submit');
toggle.addEventListener('click', e => {
  e.preventDefault();
  submitForm('form');
});

function showModal(target) {
  var modal = document.getElementById(target);
  if (modal.style.display === 'none') {
    modal.style.display = 'flex';
  } else {
    modal.style.display = 'none';
  }
};

function submitForm(target) {
  var form = document.getElementById(target);
  form.submit()
};
