const previewContainer = document.getElementById('markdown-preview-container');
const toggle = document.getElementById('article-format');

const preview = document.getElementById('markdown-preview');
const toggle2 = document.getElementById('article-body');

function initializeMarkdownPreview() {
  // 初期のプレビュー表示
  if (toggle.checked) {
    previewContainer.style.display="block";
  } else {
    previewContainer.style.display="none";
  }
  preview.innerHTML = markdownParse(toggle2.value);

  toggle.addEventListener('change', e => {
    if (e.target.checked) {
      previewContainer.style.display="block";
    } else {
      previewContainer.style.display="none";
    }
  });
  toggle2.addEventListener('input', e => {
    preview.innerHTML = markdownParse(e.target.value);
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
     .replace(/(\r\n|\r|\n)/g, '<br>\n')
     .replace(/(<\/ul>|<\/ol>)\s?<br>/g, '$1')
     .replace(/<list-19273045-n>/g, '\n');
}

initializeMarkdownPreview();
