import BootstrapKit

struct ContentStructure: HTMLComponent {

    private let primaryContent: HTML
    private let seconderyContent: HTML

    init(@HTMLBuilder primary: () -> HTML) {
        self.primaryContent = primary()
        self.seconderyContent = Div()
    }

    private init(primaryContent: HTML, seconderyContent: HTML) {
        self.primaryContent = primaryContent
        self.seconderyContent = seconderyContent
    }

    var body: HTML {
        Row {
            Div {
                primaryContent
            }
            .column(width: .eight, for: .large)
            Div {
                seconderyContent
            }
            .column(width: .four, for: .large)
        }
    }

    func secondary(@HTMLBuilder content: () -> HTML) -> ContentStructure {
        .init(primaryContent: primaryContent, seconderyContent: content())
    }
}
