import Prism from "prismjs"
export default {
    updated() {
        this.el.querySelectorAll("pre code").forEach((block) => {
            Prism.highlightElement(block)
        });
    }
}
