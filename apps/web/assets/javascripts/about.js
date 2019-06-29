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

function addHoverMotion(mouseTarget, target, motionName, fadein) {
  if (fadein) {
    mouseTarget.addEventListener("mouseover", () => {
      target.classList.remove("rot","rotrev");
      target.classList.add("animated",motionName);
      target.addEventListener("animationend", () => {
        target.classList.remove("animated",motionName);
        target.style.fill = '#fff';
        window.setTimeout(() => {
          target.classList.add("animated","fadeIn");
          target.style.fill = '#000';
          target.addEventListener("animationend", () => {
            target.classList.remove("animated","fadeIn");
          }, {once: true});
        },1);
      }, {once: true});
    });
  } else {
    mouseTarget.addEventListener("mouseover", () => {
      target.classList.remove("rot","rotrev");
      target.classList.add("animated",motionName);
      target.addEventListener("animationend", () => {
        target.classList.remove("animated",motionName);
      }, {once: true});
    });
  }
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
  addHoverMotion(s1,s1,"bounce",false);
  addHoverMotion(s2,s2,"flash",false);
  addHoverMotion(s3,s3,"rubberBand",false);
  addHoverMotion(s4,s4,"wobble",false);
  addHoverMotion(s5,s5,"heartBeat",false);
  addHoverMotion(s6,s6,"jello",false);

  addHoverMotion(dd,d1,"fadeOutLeft",true);
  addHoverMotion(dd,d2,"rotateOutUpRight",true);
  addHoverMotion(dd,d3,"fadeOutDown",true);
  addHoverMotion(dd,d4,"zoomOutLeft",true);
  addHoverMotion(dd,d5,"rotateOutDownLeft",true);
  addHoverMotion(dd,d6,"rollOut",true);
  addHoverMotion(dd,d7,"fadeOutUp",true);
  addHoverMotion(dd,d8,"lightSpeedOut",true);

  addHoverMotion(k1,k1,"bounce",false);
  addHoverMotion(k2,k2,"jello",false);
  addHoverMotion(k3,k3,"shake",false);
  addHoverMotion(k4,k4,"pulse",false);
  addHoverMotion(k5,k5,"wobble",false);
  addHoverMotion(k6,k6,"swing",false);
  addHoverMotion(k8,k8,"flash",false);
  addHoverMotion(k9,k9,"tada",false);
  addHoverMotion(k10,k10,"rubberBand",false);
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
