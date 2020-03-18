import BootstrapKit


struct Accordions<B>: HTMLComponent {

    let values: TemplateValue<[B]>
    let title: ((TemplateValue<B>, TemplateValue<Int>)) -> HTML
    let content: ((TemplateValue<B>, TemplateValue<Int>)) -> HTML
    private let footer: HTML?
    var id: String = "accordion"

    public init(values: TemplateValue<[B]>, @HTMLBuilder title: @escaping ((TemplateValue<B>, TemplateValue<Int>)) -> HTML, @HTMLBuilder content: @escaping ((TemplateValue<B>, TemplateValue<Int>)) -> HTML) {
        self.values = values
        self.title = title
        self.content = content
        self.footer = ""
    }

    private init(values: TemplateValue<[B]>, title: @escaping ((TemplateValue<B>, TemplateValue<Int>)) -> HTML, content: @escaping ((TemplateValue<B>, TemplateValue<Int>)) -> HTML, footer: HTML?) {
        self.values = values
        self.title = title
        self.content = content
        self.footer = footer
    }

    var body: HTML {
        NodeList {
            Div {
                Div {
                    ForEach(enumerated: values) { value in
                        card(value: value)
                    }
                    IF(footer != nil) {
                        Div {
                            footer ?? ""
                        }
                        .class("card-body")
                    }
                }
                .class("card")
            }
            .class("custom-accordion mb-4")
            .id(id)
        }
    }

    func card(value: (TemplateValue<B>, index: TemplateValue<Int>)) -> HTML {
        NodeList {
            heading(value: value)
            content(value: value)
        }
    }

    func heading(value: (TemplateValue<B>, index: TemplateValue<Int>)) -> HTML {
        return Div {
            Anchor {
                title(value)
            }
                .text(color: .secondary)
                .display(.block)
                .padding(.two, for: .vertical)
                .data(for: "toggle", value: "collapse")
                .data(for: "target", value: "#" + bodyId(value.index))
                .aria(for: "controls", value: bodyId(value.index))
        }
        .class("card-header")
        .id(headingId(value.index))
    }

    func content(value: (TemplateValue<B>, index: TemplateValue<Int>)) -> HTML {
        return Div {
            Div {
                content(value)
            }
            .class("card-body")
        }
        .class("collapse" + IF(value.index == 0) { " show" })
        .aria(for: "labelledby", value: headingId(value.index))
        .data(for: "parent", value: "#\(id)")
        .id(bodyId(value.index))
        .class("border-bottom border-light")
    }

    func bodyId(_ index: TemplateValue<Int>) -> HTML {
        "\(id)-body" + index
    }

    func headingId(_ index: TemplateValue<Int>) -> HTML {
        "\(id)-heading" + index
    }

    func footer(@HTMLBuilder footer: () -> HTML) -> Accordions {
        .init(values: values, title: title, content: content, footer: footer())
    }
}


struct Accordion: HTMLComponent {

    let title: TemplateValue<String>
    let content: HTML
    private let footer: HTML?
    var id: String = "accordion"

    public init(title: TemplateValue<String>, @HTMLBuilder content: () -> HTML) {
        self.title = title
        self.content = content()
        self.footer = ""
    }

    private init(title: TemplateValue<String>, content: HTML, footer: HTML?) {
        self.title = title
        self.content = content
        self.footer = footer
    }

    var body: HTML {
        Div {
            card()
            IF(footer != nil) {
                footer ?? ""
            }
        }
        .class("custom-accordion mb-4")
        .id(id)
    }

    func card() -> HTML {
        Div {
            heading()
            bodyContent()
        }
        .class("card")
        .margin(.zero, for: .bottom)
    }

    func heading() -> HTML {
        return Div {
            Anchor {
                Text {
                    title

                    Span {
                        MaterialDesignIcon(.chevronDown)
                            .class("accordion-arrow")
                    }
                    .float(.right)
                }
                .style(.heading3)
            }
                .text(color: .secondary)
                .display(.block)
                .padding(.two, for: .vertical)
                .data(for: "toggle", value: "collapse")
                .data(for: "target", value: "#accordian-body")
                .aria(for: "controls", value: "accordian-body")
        }
        .class("card-header")
    }

    func bodyContent() -> HTML {
        return Div {
            Div {
                content
            }
            .class("card-body")
        }
        .class("collapse show")
        .aria(for: "labelledby", value: "accordian-body")
        .data(for: "parent", value: "#\(id)")
        .id("accordian-body")
    }

    func footer(@HTMLBuilder footer: () -> HTML) -> Accordion {
        .init(title: title, content: content, footer: footer())
    }
}

