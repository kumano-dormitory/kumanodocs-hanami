const s1 = document.getElementById("s1");
const s2 = document.getElementById("s2");
const s3 = document.getElementById("s3");
const s4 = document.getElementById("s4");
const s5 = document.getElementById("s5");
const s6 = document.getElementById("s6");
const d1 = document.getElementById("d1");
const d2 = document.getElementById("d2");
const d3 = document.getElementById("d3");
const d4 = document.getElementById("d4");
const d5 = document.getElementById("d5");
const d6 = document.getElementById("d6");
const d7 = document.getElementById("d7");
const d8 = document.getElementById("d8");
const dd = document.getElementById("dcontainer");

function addHoverMotion(mouseTarget, target, motionName) {
  mouseTarget.addEventListener("mouseover", () => {
    target.classList.remove("rot","rotrev");
    target.classList.add("animated",motionName);
  });
  target.addEventListener("animationend", () => {
    target.classList.remove("animated",motionName);
  });
}

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
