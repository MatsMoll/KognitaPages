import BootstrapKit

public struct FormGroup: HTMLComponent {

    public var attributes: [HTMLAttribute] = []
    let label: Label
    let input: FormInput
    let optionalContent: HTML?
    private let invalidFeedback: HTML?
    private let validFeedback: HTML?

    public init(input: () -> FormInput) {
        self.label = Label()
        self.input = input()
        self.optionalContent = nil
        self.invalidFeedback = nil
        self.validFeedback = nil
    }
    public init(label: HTML, input: () -> FormInput) {
        self.label = Label { label }
        self.input = input()
        self.optionalContent = nil
        self.invalidFeedback = nil
        self.validFeedback = nil
    }

    private init(label: Label, input: FormInput, optionalContent: HTML?, invalidFeedback: HTML?, validFeedback: HTML?, attributes: [HTMLAttribute]) {
        self.label = label
        self.input = input
        self.optionalContent = optionalContent
        self.attributes = attributes
        self.invalidFeedback = invalidFeedback
        self.validFeedback = validFeedback
    }

    public var body: HTML {
        guard let inputId = input.value(of: "id") else {
            fatalError("Missing an id attribute on an Input in a FormGroup")
        }
        var inputNode = input
        if input.value(of: "name") == nil {
            inputNode = input.add(.init(attribute: "name", value: inputId), withSpace: false)
        }
        return Div {
            label.for(inputId)
            inputNode.class("form-control")
            IF(validFeedback != nil) {
                Div {
                    validFeedback ?? ""
                }.class("valid-feedback")
            }
            IF(invalidFeedback != nil) {
                Div {
                    invalidFeedback ?? ""
                }.class("invalid-feedback")
            }
            IF(optionalContent != nil) {
                Small {
                    optionalContent ?? ""
                }.class("form-text")
            }
        }
        .class("form-group")
        .add(attributes: attributes)
    }

    func description(@HTMLBuilder content: () -> HTML) -> FormGroup {
        .init(label: label, input: input, optionalContent: content(), invalidFeedback: invalidFeedback, validFeedback: validFeedback, attributes: attributes)
    }

    func customLabel(@HTMLBuilder content: () -> HTML) -> FormGroup {
        .init(label: Label { content() }, input: input, optionalContent: optionalContent, invalidFeedback: invalidFeedback, validFeedback: validFeedback, attributes: attributes)
    }

    func invalidFeedback(@HTMLBuilder feedback: () -> HTML) -> FormGroup {
        .init(label: label, input: input, optionalContent: optionalContent, invalidFeedback: feedback(), validFeedback: validFeedback, attributes: attributes)
    }

    func validFeedback(@HTMLBuilder feedback: () -> HTML) -> FormGroup {
        .init(label: label, input: input, optionalContent: optionalContent, invalidFeedback: invalidFeedback, validFeedback: feedback(), attributes: attributes)
    }
}

extension FormGroup: AttributeNode {
    public func copy(with attributes: [HTMLAttribute]) -> FormGroup {
        .init(label: label, input: input, optionalContent: optionalContent, invalidFeedback: invalidFeedback, validFeedback: validFeedback, attributes: attributes)
    }
}
