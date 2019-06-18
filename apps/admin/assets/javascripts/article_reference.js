const articleSameReferences = document.getElementById('article-same-references');
const sameRefsSearchInput = document.getElementById('same-refs-search-input');
const sameRefsSearchReset = document.getElementById('same-refs-search-reset');
const sameRefsSelectedList = document.getElementById('same-refs-selected');

const articleOtherReferences = document.getElementById('article-other-references');
const otherRefsSearchInput = document.getElementById('other-refs-search-input');
const otherRefsSearchReset = document.getElementById('other-refs-search-reset');
const otherRefsSelectedList = document.getElementById('other-refs-selected');


function selectArticle(select, attributeName)
{
  var option = select.options[select.selectedIndex];
  var ul = select.parentNode.getElementsByTagName('ul')[0];

  var choices = ul.getElementsByTagName('input');
  for (var i = 0; i < choices.length; i++)
    if (choices[i].value == option.value)
      return;

  if (option.value == 0) { return; }

  var li = document.createElement('li');
  var input = document.createElement('input');
  var text = document.createTextNode(option.firstChild.data);
  var icon = document.createElement('i');

  li.setAttribute('class', 'p-list__item is-ticked');
  li.setAttribute('style', 'padding-bottom: .25rem; padding-top: .25rem;');
  input.type = 'hidden';
  input.name = `article[${attributeName}][]`;
  input.value = option.value;
  icon.setAttribute('class', 'p-icon--error');
  icon.setAttribute('style', 'height:1.3rem;width:1.3rem;margin-left:1rem;');

  li.appendChild(text);
  li.appendChild(input);
  li.appendChild(icon);
  icon.addEventListener('click', () => li.parentNode.removeChild(li));

  ul.appendChild(li);
  select.selectedIndex = 0;
}

function searchArticle(search, select) {
  var options = select.options;
  var search_regex = new RegExp(`.*${search.value}.*`);
  for (var i = 0; i < options.length; i++) {
    var title = options[i].textContent;
    if (search_regex.test(title)) {
      options[i].style.display = 'block';
    } else {
      options[i].style.display = 'none';
    }
  }
}

function initializeList(ulElement) {
  var choices = ulElement.getElementsByTagName('i');
  for (var i = 0; i < choices.length; i++) {
    var icon = choices[i];
    icon.addEventListener('click', (e) => ulElement.removeChild(e.target.parentNode));
  }
}

articleSameReferences.addEventListener('change', () => selectArticle(articleSameReferences, 'same_refs_selected'));
sameRefsSearchInput.addEventListener('input', () => searchArticle(sameRefsSearchInput, articleSameReferences));
sameRefsSearchInput.addEventListener('search', (e) => {e.preventDefault(); articleSameReferences.focus();});
sameRefsSearchReset.addEventListener('click', () => searchArticle({value: ''}, articleSameReferences));
initializeList(sameRefsSelectedList);

articleOtherReferences.addEventListener('change', () => selectArticle(articleOtherReferences, 'other_refs_selected'));
otherRefsSearchInput.addEventListener('input', () => searchArticle(otherRefsSearchInput, articleOtherReferences));
otherRefsSearchInput.addEventListener('search', (e) => {e.preventDefault(); articleOtherReferences.focus();});
otherRefsSearchReset.addEventListener('click', () => searchArticle({value: ''}, articleOtherReferences));
initializeList(otherRefsSelectedList);
