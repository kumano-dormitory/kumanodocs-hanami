var baseW = 980;	//基準となるブレークポイント
var baseMin = 420;
var iOSviewportW = 0;
var ua = navigator.userAgent.toLowerCase();
var isiOS = (ua.indexOf("iphone") > -1) || (ua.indexOf("ipod") > -1) || (ua.indexOf("ipad") > -1);
if(isiOS){
	iOSviewportW = document.documentElement.clientWidth;
}
function updateMetaViewport(){
	var viewportContent;
	var w = window.outerWidth;
	if(isiOS){
		w = iOSviewportW;
	}
  if(window.matchMedia('(display-mode: standalone)').matches) {
    // PWA起動
    if (w > baseMin){
      viewportContent = "width=device-width,initial-scale=1,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no";
    }else{
      viewportContent = "width="+baseMin+",initial-scale="+(w/baseMin)+"minimum-scale="+(w/baseMin)+",maximum-scale="+(w/baseMin)+",user-scalable=no";
    }
  } else {
    if (w > baseMin){
      viewportContent = "width=device-width,initial-scale=1";
    }else{
      viewportContent = "width="+baseMin+",initial-scale="+(w/baseMin);
    }
  }
	document.querySelector("meta[name='viewport']").setAttribute("content", viewportContent);
}
//イベントハンドラ登録
window.addEventListener("resize", updateMetaViewport, false);
window.addEventListener("orientationchange", updateMetaViewport, false);
//初回イベント強制発動
var ev = document.createEvent("UIEvent");
ev.initEvent("resize", true, true)
window.dispatchEvent(ev);
