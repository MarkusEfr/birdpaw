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
    const birdElement = this.el.querySelector('#bird');
    let frame = 0;
    const frames = [
      "/images/bird/1.png",  // Path to first bird frame
      "/images/bird/2.png",  // Path to second bird frame
      // "/images/bird/3.png",  // Path to third bird frame
      // "/images/bird/4.png"   // Path to fourth bird frame (add more as needed)
    ];
    const totalFrames = frames.length;

    const animateBird = () => {
      frame = (frame + 1) % totalFrames;
      birdElement.src = frames[frame];
    };

    this.interval = setInterval(animateBird, 200); // Switch frames every 200ms
  },

  destroyed() {
    clearInterval(this.interval);
  }
};

hooks.CopyToClipboard = {
  mounted() {
    const copyButton = this.el;

    // Detect if we are copying from mobile or desktop
    const contractAddressElement = this.el.id === "copy-btn-mobile"
      ? document.getElementById("contract-address-mobile")
      : document.getElementById("contract-address");

    const feedbackElement = this.el.id === "copy-btn-mobile"
      ? document.getElementById("copy-feedback-mobile")
      : document.getElementById("copy-feedback");

    copyButton.addEventListener('click', () => {
      const contractAddress = contractAddressElement.textContent;

      // Create a temporary input to copy the text
      const tempInput = document.createElement('input');
      document.body.appendChild(tempInput);
      tempInput.value = contractAddress;
      tempInput.select();
      document.execCommand('copy');
      document.body.removeChild(tempInput);

      // Show the "Copied" message
      feedbackElement.classList.remove('hidden');

      // Hide the feedback message after 2 seconds
      setTimeout(() => {
        feedbackElement.classList.add('hidden');
      }, 2000);
    });
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
