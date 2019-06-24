function fontSize(fsize){
  $('#content').css('font-size', fsize);
}
document.getElementById('text-size-9pt').addEventListener('click', () => fontSize('9pt'));
document.getElementById('text-size-10pt').addEventListener('click', () => fontSize('10pt'));
document.getElementById('text-size-11pt').addEventListener('click', () => fontSize('11pt'));
document.getElementById('text-size-12pt').addEventListener('click', () => fontSize('12pt'));
document.getElementById('text-size-13pt').addEventListener('click', () => fontSize('13pt'));
document.getElementById('text-size-14pt').addEventListener('click', () => fontSize('14pt'));
document.getElementById('text-size-16pt').addEventListener('click', () => fontSize('16pt'));
document.getElementById('text-size-18pt').addEventListener('click', () => fontSize('18pt'));
document.getElementById('text-size-20pt').addEventListener('click', () => fontSize('20pt'));

function updateMsg() {
  var docHeight = $(document).innerHeight();
  var windowHeight = window.innerHeight;
  var ua = navigator.userAgent;
  var pageBottom = docHeight - windowHeight;
  if (ua.indexOf('iPhone') > 0 || ua.indexOf('iPod') > 0 || ua.indexOf('Android') > 0 && ua.indexOf('Mobile') > 0) {
        pageBottom = pageBottom - 60;
  } else if (ua.indexOf('iPad') > 0 || ua.indexOf('Android') > 0) {
        pageBottom = pageBottom - 80;
  } else {
        pageBottom = pageBottom - 200;
  }
  if (pageBottom <= $(window).scrollTop()) {
    setTimeout(function() {
      window.scroll(0,$(document).height());
    },0);
    $.ajax({
      url: "/gijiroku/content",
      cache: false,
      success: function(html){
        $("#content").html(html);
      }
    });
  }
  else {
    $.ajax({
      url: "/gijiroku/content",
      cache: false,
      success: function(html){
        $("#content").html(html);
      }
    });
  }
  setTimeout(() => updateMsg(),5000);
}
updateMsg();
