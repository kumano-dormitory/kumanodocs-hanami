const markdownTab = document.getElementById('markdown-tab');
const preview = document.getElementById('markdown-preview');
const toggle = document.getElementById('article-format');
const toggle2 = document.getElementById('article-body');
const tab1 = document.getElementById('tab-write');
const tab2 = document.getElementById('tab-preview');

function initializeMarkdownPreview() {
  // 初期のMarkdownプレビューのタブ表示
  if (toggle.checked) {
    markdownTab.style.display="block";
  } else {
    markdownTab.style.display="none";
  }
  preview.innerHTML = markdownParse(toggle2.value);
  preview.style.display="none";
  preview.style.minHeight="45rem";

  // イベントハンドラの登録
  toggle.addEventListener('change', e => {
    if (e.target.checked) {
      markdownTab.style.display="block";
      toggle2.style.display="block";
      preview.style.display="none";
      tab1.setAttribute('aria-selected', 'true');
      tab2.setAttribute('aria-selected', 'false');
    } else {
      markdownTab.style.display="none";
      toggle2.style.display="block";
      preview.style.display="none";
      tab1.setAttribute('aria-selected', 'true');
      tab2.setAttribute('aria-selected', 'false');
    }
  });
  toggle2.addEventListener('input', e => {
    preview.innerHTML = markdownParse(e.target.value);
  });
  tab1.addEventListener('click', e => {
    e.preventDefault();
    toggle2.style.display="block";
    preview.style.display="none";
    tab1.setAttribute('aria-selected', 'true');
    tab2.setAttribute('aria-selected', 'false');
  });
  tab2.addEventListener('click', e => {
    e.preventDefault();
    toggle2.style.display="none";
    preview.style.display="block";
    tab1.setAttribute('aria-selected', 'false');
    tab2.setAttribute('aria-selected', 'true');
  });

}

function ulReplacer(match, p1) {
  var item = p1.trim();
  return `\n<ul><list-19273045-n><li>${item}</li><list-19273045-n></ul>`;
}

function olReplacer(match, p1) {
  var item = p1.trim();
  return `<ol><list-19273045-n><li>${item}</li><list-19273045-n></ol>`;
}

function markdownParse(markdownStr) {
  if (markdownStr === "") {
    return 'プレビューとして表示できるものがありません<br/>本文を入力してください';
  }
  return markdownStr
     .replace(/&/, '&amp;')
     .replace(/</g, '&lt;')
     .replace(/>/g, '&gt;')
     .replace(/###\s(.+?)(\r\n|\r|\n)/g, '<h4 class="full-width">$1</h4>$2')
     .replace(/##\s(.+?)(\r\n|\r|\n)/g, '<h3 class="full-width">$1</h3>$2')
     .replace(/#\s(.+?)(\r\n|\r|\n)/g, '<h2 class="full-width">$1</h2>$2')
     .replace(/__(.+?)__/g, '<strong style="font-weight: 800;">$1</strong>')
     .replace(/\*\*(.+?)\*\*/g, '<strong style="font-weight: 800;">$1</strong>')
     .replace(/_(.+?)_/g, '<u>$1</u>')
     .replace(/\*(.+?)\*/g, '<em>$1</em>')
     .replace(/\n\*\s(.*?$)/gm, ulReplacer)
     .replace(/\n\d+\.\s(.*?$)/gm, olReplacer)
     .replace(/\n-{4,}/g, '<list-19273045-n><hr />')
     .replace(/<\/ul>\s?<ul>/g, '')
     .replace(/<\/ol>\s?<ol>/g, '')
     .replace(/(<\/h4>|<\/h3>|<\/h2>)(\r\n|\r|\n)/g, '$1')
     .replace(/(\r\n|\r|\n)/g, '<br>\n')
     .replace(/(<\/ul>|<\/ol>)\s?<br>/g, '$1')
     .replace(/<list-19273045-n>/g, '\n');
}

initializeMarkdownPreview();
