import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"
import AnimateOnScroll from "./hooks/animate_on_scroll"
import anime from 'animejs/lib/anime.es.js';

let hooks = {};

// Hook for Floating Text animation
hooks.FloatingText = {
  mounted() {
    let textWrapper = this.el;
    // Apply anime.js animation on the mounted element
    anime({
      targets: textWrapper,
      opacity: [0, 1],
      translateY: [-20, 0],
      duration: 1500,
      easing: 'easeOutExpo',
      delay: anime.stagger(100) // stagger effect for text elements
    });
  }
};

// Hook for Bubble Animation (using anime.js for continuous floating animation)
hooks.BubbleAnimation = {
  mounted() {
    let bubbles = this.el.querySelectorAll(".bubble");
    // Apply anime.js animation on bubbles
    anime({
      targets: bubbles,
      translateY: [-10, 10],
      loop: true,
      direction: "alternate",
      easing: "easeInOutSine",
      duration: anime.stagger(3000, { start: 1000 }),
      delay: anime.stagger(200),
    });
  }
};

// Hook for Button Animation on hover
hooks.AnimatedButton = {
  mounted() {
    let button = this.el;
    // Add hover event to trigger anime.js scaling animation
    button.addEventListener("mouseenter", () => {
      anime({
        targets: button,
        scale: 1.1,
        duration: 300,
        easing: 'easeOutExpo'
      });
    });
    button.addEventListener("mouseleave", () => {
      anime({
        targets: button,
        scale: 1,
        duration: 300,
        easing: 'easeOutExpo'
      });
    });
  }
};

hooks.BirdAnimation = {
  mounted() {
    const birdElement = this.el;
    let birdImages = ['/images/bird1.png', '/images/bird2.png', '/images/bird3.png']; // Add as many as you have

    function animateBird() {
      anime({
        targets: birdElement,
        translateX: [0, 50], // Horizontal movement
        translateY: [0, -10], // Vertical movement
        duration: 5000,
        easing: 'easeInOutQuad',
        loop: true,
        direction: 'alternate',
        complete: () => {
          // Change bird image every time the animation completes
          let randomBird = birdImages[Math.floor(Math.random() * birdImages.length)];
          birdElement.src = randomBird;
        }
      });
    }

    animateBird();
  }
};
// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  hooks: hooks,
  params: { _csrf_token: csrfToken }
})

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
