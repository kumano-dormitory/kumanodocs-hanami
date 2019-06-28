const kline = document.getElementById("kline");
const k1 = document.getElementById("k1");
const k2 = document.getElementById("k2");
const k3 = document.getElementById("k3");
const k4 = document.getElementById("k4");
const k5 = document.getElementById("k5");
const k6 = document.getElementById("k6");
const k7 = document.getElementById("k7");
const k8 = document.getElementById("k8");
const k9 = document.getElementById("k9");
const k10 = document.getElementById("k10");
const sline = document.getElementById("sline");
const ss = document.getElementById("scontainer");
const s1 = document.getElementById("s1");
const s2 = document.getElementById("s2");
const s3 = document.getElementById("s3");
const s4 = document.getElementById("s4");
const s5 = document.getElementById("s5");
const s6 = document.getElementById("s6");
const dline = document.getElementById("dline");
const dwider = document.getElementById("dwider");
const d1 = document.getElementById("d1");
const d2 = document.getElementById("d2");
const d3 = document.getElementById("d3");
const d4 = document.getElementById("d4");
const d5 = document.getElementById("d5");
const d6 = document.getElementById("d6");
const d7 = document.getElementById("d7");
const d8 = document.getElementById("d8");
const dd = document.getElementById("dcontainer");
const descline = document.getElementById("descline");
const restartbutton = document.getElementById("restartbutton");

function addHoverMotion(mouseTarget, target, motionName) {
  mouseTarget.addEventListener("mouseover", () => {
    target.classList.remove("rot","rotrev");
    target.classList.add("animated",motionName);
  });
  target.addEventListener("animationend", () => {
    target.classList.remove("animated",motionName);
  });
}
function resetAnimateClass(target,motionName,speedName,delayName) {
  if (speedName === "") {
    target.classList.add("animated",motionName,delayName);
    target.addEventListener("animationend",() => {
      target.classList.remove("animated",motionName,delayName);
    });
  } else {
    target.classList.add("animated",motionName,speedName,delayName);
    target.addEventListener("animationend",() => {
      target.classList.remove("animated",motionName,speedName,delayName);
    });
  }
}
function resetClass(target,className) {
  target.classList.add(className);
  target.addEventListener("animationend",() => {
    target.classList.remove(className);
  });
}

function initialize() {
  resetAnimation();
  addHoverMotion(s1,s1,"bounce");
  addHoverMotion(s2,s2,"flash");
  addHoverMotion(s3,s3,"rubberBand");
  addHoverMotion(s4,s4,"wobble");
  addHoverMotion(s5,s5,"heartBeat");
  addHoverMotion(s6,s6,"jello");

  addHoverMotion(dd,d1,"fadeOutLeft");
  addHoverMotion(dd,d2,"rotateOutUpRight");
  addHoverMotion(dd,d3,"fadeOutDown");
  addHoverMotion(dd,d4,"zoomOutLeft");
  addHoverMotion(dd,d5,"rotateOutDownLeft");
  addHoverMotion(dd,d6,"rollOut");
  addHoverMotion(dd,d7,"fadeOutUp");
  addHoverMotion(dd,d8,"lightSpeedOut");
}

function resetAnimation() {
  resetAnimateClass(kline,"fadeInDown","slower","delay-1s");
  resetAnimateClass(dline,"lightSpeedIn","","delay-2s");
  resetAnimateClass(sline,"rollIn","slow","delay-3s");
  resetAnimateClass(descline,"jackInTheBox","slower","delay-4s");
  resetAnimateClass(k1,"tada","","delay-5s");
  resetAnimateClass(k2,"shake","","delay-5s");
  resetAnimateClass(k3,"swing","","delay-5s");
  resetAnimateClass(k4,"bounce","","delay-5s");
  resetAnimateClass(k5,"pulse","","delay-5s");
  resetAnimateClass(k6,"jello","","delay-5s");
  resetAnimateClass(k8,"rubberBand","","delay-5s");
  resetAnimateClass(k9,"wobble","","delay-5s");
  resetAnimateClass(k10,"flash","","delay-5s");
  resetClass(dwider,"wider");
  resetClass(ss,"taller");
  resetClass(s1,"rotrev");
  resetClass(s2,"rotrev");
  resetClass(s3,"rotrev");
  resetClass(s4,"rotrev");
  resetClass(s5,"rotrev");
  resetClass(s6,"rotrev");
  resetClass(d1,"rot");
  resetClass(d2,"rot");
  resetClass(d3,"rot");
  resetClass(d4,"rot");
  resetClass(d5,"rot");
  resetClass(d6,"rot");
  resetClass(d7,"rot");
  resetClass(d8,"rot");
  resetAnimateClass(restartbutton,"fadeIn","slower","delay-5s");
}
restartbutton.addEventListener("click", () => {
  resetAnimation();
});
initialize();
