// We need to import css for webpack to find it
import "../css/app.css"

// Phoenix imports
import "phoenix_html"
import {
    Socket
} from "phoenix"
import NProgress from "nprogress"
import {
    LiveSocket
} from "phoenix_live_view"

const Hooks = {};

// Monaco Editor
Hooks.MonacoEditor = {
    mounted() {
        NProgress.start()
        import( /* webpackChunkName: "monaco" */ "monaco-editor").then(monaco => {
            let server_change = false;

            this.edit = monaco.editor.create(this.el, {
                value: this.el.dataset.raw,
                language: "markdown",
                automaticLayout: true,
            })

            this.edit.getModel().onDidChangeContent(e => {
                if (!server_change) {
                    this.pushEvent("update", {
                        value: this.edit.getModel().getValue(),
                    })
                }
                server_change = false;
            });

            this.handleEvent("update_monaco", ({
                content
            }) => {
                server_change = true;
                this.edit.getModel().setValue(content);
            })
        });
        NProgress.done()
    }
}

import Prism from "prismjs"
Hooks.Prism = {
    updated() {
        this.el.querySelectorAll("pre code").forEach((block) => {
            Prism.highlightElement(block)
        });
    }
}

Hooks.StealFocus = {
    updated() {
        // On update find the first text field and focus it.
        const inputs = this.el.getElementsByTagName("input");
        for(const field of inputs){
            if(field.type == "text") {
                field.select();
                break;
            }
        }
    }
}

import cytoscape from "cytoscape"
Hooks.CytoScape = {
    graph() {
        return JSON.parse(document.getElementById(this.el.id).dataset.graph)
    },
    mounted() {
        this.container = document.getElementById(this.el.id + "-container");

        this.cy = cytoscape({
            container: this.container,
            elements: this.graph(),
            style: [{
                    selector: 'node',
                    style: {
                        'background-color': '#333',
                        'label': 'data(label)'
                    }
                },
                {
                    selector: 'edge',
                    style: {
                        'width': 5,
                        'line-color': '#ccc',
                        'target-arrow-color': '#ccc',
                        'target-arrow-shape': 'triangle',
                        'curve-style': 'bezier'
                    }
                },
            ],
        });

        this.cy.elements().layout({
            name: 'cose',
            nodeDimensionsIncludeLabels: true,
            animate: false
        }).run();
    },
    updated() {
        this.cy.json({
            elements: this.graph()
        })
        // this.cy.elements().layout({
        //     name: 'cose',
        //     nodeDimensionsIncludeLabels: true,
        //     animate: false
        // }).run();
    }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
    hooks: Hooks,
    params: {
        _csrf_token: csrfToken
    }
})

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", info => NProgress.start())
window.addEventListener("phx:page-loading-stop", info => NProgress.done())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
