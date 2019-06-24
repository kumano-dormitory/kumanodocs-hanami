var diffOutputFormat = 'line-by-line';
var diffOptionContext = '4';
var diffOptionFontSize = '10pt';

function changeDiffFontSize(size) {
  if (size === '') {
    size = diffOptionFontSize;
  } else {
    diffOptionFontSize = size;
  }
  var diffTables = document.getElementsByClassName('d2h-diff-table');
  for(var i = 0; i < diffTables.length; i++) {
    diffTables[i].style.fontSize = size;
  }
}

function toggleDiffHtml(target, outputFormat, context) {
  // line-by-line: 96, side-by-side: 65
  if (outputFormat === '') {
    outputFormat = diffOutputFormat;
  } else {
    diffOutputFormat = outputFormat;
  }
  if (context === '') {
    context = diffOptionContext;
  } else {
    diffOptionContext = context;
  }
  var breakpoint = 96;
  if (outputFormat === 'side-by-side') {
    breakpoint = 65;
  }
  var articleOldTitle = document.getElementById('articleOldTitle').textContent;
  var articleOldBody = '';

  var lines = document.getElementById('articleOldBody').textContent.replace(/。/g, '。\n').split('\n');
  lines.forEach((line) => {
    if (line.length > breakpoint) {
      articleOldBody = articleOldBody + '\n' + line.replace(/(.{15,})(,|、|，|\.|．)/, '$1$2\n');
    } else {
      articleOldBody = articleOldBody + '\n' + line;
    }
  });

  var articleNewTitle = document.getElementById('articleNewTitle').textContent;
  var articleNewBody = '';
  lines = document.getElementById('articleNewBody').textContent.replace(/。/g, '。\n').split('\n');
  lines.forEach((line) => {
    if (line.length > breakpoint) {
      articleNewBody = articleNewBody + '\n' + line.replace(/(.{15,})(,|、|，|\.|．)/, '$1$2\n');
    } else {
      articleNewBody = articleNewBody + '\n' + line;
    }
  });
  var unifiedDiff = Diff.createPatch("", articleOldBody, articleNewBody, articleOldTitle, articleNewTitle, {context: parseInt(context, 10)});
  var diffHtml = Diff2Html.getPrettyHtml(
    unifiedDiff,
    {inputFormat: 'diff', showFiles: false, matching: 'none', outputFormat: outputFormat}
  );
  target.innerHTML = diffHtml;
  if (outputFormat === 'side-by-side') {
    target.setAttribute('style', 'max-width: 95%;');
  } else {
    target.setAttribute('style', 'max-width: 87rem;');
  }
  changeDiffFontSize('');
}

function filterArticles(select, value) {
  var options = select.options;
  if (value === '0') {
    for(var i = 0; i < options.length; i++) {
      options[i].style.display = 'block';
    }
    select.selectedIndex = 0;
    return;
  }
  var search_regex = new RegExp(`^${value}.*`);
  for (var i = 1; i < options.length; i++) {
    var title = options[i].textContent;
    if (search_regex.test(title)) {
      options[i].style.display = 'block';
    } else {
      options[i].style.display = 'none';
    }
  }
  select.selectedIndex = 0;
}

document.addEventListener('DOMContentLoaded', function() {
    const target = document.getElementById('diffRoot');
    toggleDiffHtml(target, 'line-by-line', '4');
    const diffOutputFormatSelect = document.getElementById('diff-options-output-format');
    if (diffOutputFormatSelect) {
      diffOutputFormatSelect.addEventListener('change', (e) => toggleDiffHtml(target, e.target.value, ''));
    }
    const diffOptionContextSelect = document.getElementById('diff-options-context');
    if (diffOptionContextSelect) {
      diffOptionContextSelect.addEventListener('change', (e) => toggleDiffHtml(target, '', e.target.value));
    }
    const diffOptionFontSizeSelect = document.getElementById('diff-options-font-size');
    if (diffOptionFontSize) {
      diffOptionFontSizeSelect.addEventListener('change', (e) => changeDiffFontSize(e.target.value));
    }
    const diffSelectOldMeeting = document.getElementById('diff-old-meeting');
    const diffSelectOldArticle = document.getElementById('diff-old-article');
    const diffSelectNewMeeting = document.getElementById('diff-new-meeting');
    const diffSelectNewArticle = document.getElementById('diff-new-article');
    if (diffSelectOldMeeting) {
      diffSelectOldMeeting.addEventListener('change', (e) => filterArticles(diffSelectOldArticle, e.target.value));
    }
    if (diffSelectNewMeeting) {
      diffSelectNewMeeting.addEventListener('change', (e) => filterArticles(diffSelectNewArticle, e.target.value));
    }
});
