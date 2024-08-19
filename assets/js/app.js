import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"
import AnimateOnScroll from "./hooks/animate_on_scroll"

let hooks = {}

hooks.ScrollReveal = {
  mounted() {
    const options = {
      root: null,
      rootMargin: '0px',
      threshold: 0.1
    }

    const callback = (entries, observer) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.add('animate-fadeInUp')
          observer.unobserve(entry.target)
        }
      })
    }

    const observer = new IntersectionObserver(callback, options)
    const items = document.querySelectorAll('.timeline-item')
    items.forEach(item => observer.observe(item))
  }
}

hooks.AnimateOnScroll = AnimateOnScroll
hooks.PromoAnimation = {
  mounted() {
    // Initially hide the elements
    const promoHeader = this.el.querySelector('#promo-header');
    const promoMemeText = this.el.querySelector('#promo-meme-text');

    if (promoHeader) {
      promoHeader.classList.add('opacity-0', 'scale-95', 'transition-all', 'duration-1000', 'ease-out');
    }
    if (promoMemeText) {
      promoMemeText.classList.add('opacity-0', 'scale-95', 'transition-all', 'duration-1000', 'ease-out');
    }

    // Fade in and scale up the elements smoothly
    setTimeout(() => {
      if (promoHeader) {
        promoHeader.classList.remove('opacity-0', 'scale-95');
        promoHeader.classList.add('opacity-100', 'scale-100');
      }
      if (promoMemeText) {
        promoMemeText.classList.remove('opacity-0', 'scale-95');
        promoMemeText.classList.add('opacity-100', 'scale-100');
      }
    }, 500);

    // Stop animation after elements are fully shown
    setTimeout(() => {
      if (promoHeader) {
        promoHeader.classList.remove('animate-pulse');
      }
      if (promoMemeText) {
        promoMemeText.classList.remove('animate-bounce');
      }
    }, 1500);
  }
}


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
