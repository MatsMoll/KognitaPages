import BootstrapKit


struct Modal: HTMLComponent, AttributeNode {

    let title: HTML
    let content: HTML
    let id: HTML
    var attributes: [HTMLAttribute]

    init(title: HTML, id: HTML, @HTMLBuilder content: () -> HTML) {
        self.title = title
        self.content = content()
        self.id = id
        self.attributes = []
    }

    init(title: HTML, id: HTML, content: HTML, attributes: [HTMLAttribute]) {
        self.title = title
        self.content = content
        self.id = id
        self.attributes = attributes
    }

    var body: HTML {
        Div {
            Div {
                Div {
                    Div {
                        H4 {
                            title
                        }
                        .class("modal-title")
                        .id("practice-modal-label")

                        Button {
                            "×"
                        }
                        .type("button")
                        .class("close")
                        .data(for: "dismiss", value: "modal")
                        .aria(for: "hidden", value: "true")
                    }
                    .class("modal-header bg-light")

                    Div {
                        Div {
                            content
                        }
                        .class("p-2")
                    }
                    .class("modal-body")
                }
                .class("modal-content")
            }
            .class("modal-dialog modal-dialog-centered modal-lg")
        }
        .class("modal fade")
        .id(id)
        .role("dialog")
        .aria(for: "labelledby", value: id)
        .aria(for: "hidden", value: "true")
    }

    func copy(with attributes: [HTMLAttribute]) -> Modal {
        .init(title: title, id: id, content: content, attributes: attributes)
    }

    func id(_ value: HTML) -> Modal {
        .init(title: title, id: value, content: content, attributes: attributes)
    }
}
