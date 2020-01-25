import BootstrapKit

struct CustomControlInput: HTMLComponent, AttributeNode {

    enum InputType {
        case checkbox
        case radio
    }

    let label: Label
    let type: Input.Types
    var attributes: [HTMLAttribute]
    let identifier: HTML


    public init(label: HTML, type: Input.Types, id: HTML) {
        self.label = Label { label }
        self.type = type
        self.identifier = id
        self.attributes = []
    }

    private init(label: Label, type: Input.Types, identifier: HTML, attributes: [HTMLAttribute]) {
        self.label = label
        self.type = type
        self.attributes = attributes
        self.identifier = identifier
    }

    var body: HTML {
        Div {
            Input()
                .type(type)
                .class("custom-control-input")
                .id(identifier)
            label.class("custom-control-label")
                .for(identifier)
        }
        .class("custom-control")
        .modify(if: type == .checkbox) {
            $0.class("custom-checkbox")
        }
        .modify(if: type == .radio) {
            $0.class("custom-radio")
        }
    }

    func copy(with attributes: [HTMLAttribute]) -> CustomControlInput {
        .init(label: label, type: type, identifier: identifier, attributes: attributes)
    }
}
