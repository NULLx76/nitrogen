import cytoscape from "cytoscape"
export default {
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
    }
}
