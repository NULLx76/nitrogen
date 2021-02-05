// We need to import css for webpack to find it
import "animate.css";
import "nprogress/nprogress.css"
import "../css/app.css"

// Phoenix imports
import "phoenix_html"
import { Socket } from "phoenix"
import NProgress from "nprogress"
import { LiveSocket } from "phoenix_live_view"

// Hooks
import { CytoscapeHook, StealFocusHook, PrismHook, MonacoHook } from "./hooks"

const Hooks = {
    MonacoEditor: MonacoHook,
    Prism: PrismHook,
    StealFocus: StealFocusHook,
    CytoScape: CytoscapeHook
};

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
    hooks: Hooks,
    params: { _csrf_token: csrfToken }
});

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", _info => NProgress.start())
window.addEventListener("phx:page-loading-stop", _info => {
    if (document.getElementById("monaco-editor")) {
        NProgress.inc(0.8);
    } else {
        NProgress.done();
    }
})

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
