import NProgress from "nprogress"
export default {
    mounted() {
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

            this.handleEvent("update_monaco", ({ content }) => {
                server_change = true;
                this.edit.getModel().setValue(content);
            })
            NProgress.done();
        });
    }
}
