const docTypeSelect = document.getElementById('document-type');
const formBodyGroup = document.getElementById('document-body-group');
const formBody = document.getElementById('document-body');
const formDataGroup = document.getElementById('document-data-group');
const formData = document.getElementById('document-data');
const formUrlGroup = document.getElementById('document-url-group');
const formUrl = document.getElementById('document-url');

function initialize() {
  var idx = docTypeSelect.selectedIndex;
  var type = docTypeSelect.options[idx].value
  if (type == '0') {
    formBodyGroup.style.display = 'grid';
    formDataGroup.style.display = 'none';
    formUrlGroup.style.display = 'none';

  } else if (type == '1') {
    formBodyGroup.style.display = 'none';
    formDataGroup.style.display = 'grid';
    formUrlGroup.style.display = 'none';
  } else if (type == '2') {
    formBodyGroup.style.display = 'none';
    formDataGroup.style.display = 'none';
    formUrlGroup.style.display = 'grid';
  }

  docTypeSelect.addEventListener('change', e => {
    var idx = e.target.selectedIndex;
    var type = e.target.options[idx].value;
    if (type == '0') {
      formBodyGroup.style.display = 'grid';
      formDataGroup.style.display = 'none';
      formData.value = "";
      formUrlGroup.style.display = 'none';
      formUrl.value = "";
    } else if (type == '1') {
      formBodyGroup.style.display = 'none';
      formBody.value = "";
      formDataGroup.style.display = 'grid';
      formUrlGroup.style.display = 'none';
      formUrl.value = "";
    } else if (type == '2') {
      formBodyGroup.style.display = 'none';
      formBody.value = "";
      formDataGroup.style.display = 'none';
      formData.value = "";
      formUrlGroup.style.display = 'grid';
    }
  });
}

initialize();
