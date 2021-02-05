export default {
    updated() {
        // On update find the first text field and focus it.
        const inputs = this.el.getElementsByTagName("input");
        for (const field of inputs) {
            if (field.type == "text") {
                field.select();
                break;
            }
        }
    }
}
