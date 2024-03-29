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
    let name: HTML
    let value: HTML?
    private let isChecked: Conditionable

    public init(label: HTML, type: Input.Types, id: HTML, name: HTML? = nil, value: HTML? = nil) {
        self.label = Label { label }
        self.type = type
        self.identifier = id
        self.attributes = []
        self.name = name ?? id
        self.value = value
        self.isChecked = false
    }

    private init(label: Label, type: Input.Types, identifier: HTML, isChecked: Conditionable, attributes: [HTMLAttribute], name: HTML, value: HTML?) {
        self.label = label
        self.type = type
        self.attributes = attributes
        self.identifier = identifier
        self.isChecked = isChecked
        self.name = name
        self.value = value
    }

    var body: HTML {
        Div {
            Input()
                .type(type)
                .class("custom-control-input")
                .id(identifier)
                .add(HTMLAttribute(attribute: "name", value: name))
                .isChecked(isChecked)
                .value(value ?? "")
            label.class("custom-control-label")
                .for(identifier)
        }
        .class("custom-control")
        .add(attributes: attributes)
        .modify(if: type == .checkbox) {
            $0.class("custom-checkbox")
        }
        .modify(if: type == .radio) {
            $0.class("custom-radio")
        }
    }

    public func isChecked(_ condition: Conditionable) -> CustomControlInput {
        .init(label: label, type: type, identifier: identifier, isChecked: condition, attributes: attributes, name: name, value: value)
    }

    func copy(with attributes: [HTMLAttribute]) -> CustomControlInput {
        .init(label: label, type: type, identifier: identifier, isChecked: isChecked, attributes: attributes, name: name, value: value)
    }
}
