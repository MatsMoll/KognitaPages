import HTMLKit

extension AttributeNode {

    func toggle(modal id: HTMLIdentifier) -> Self {
        self.data(for: "toggle", value: "modal")
            .data(for: "target", value: id)
    }
}

extension Input {
    func autofocus() -> Self {
        self.add(.init(attribute: "autofocus", value: nil))
    }
}

extension TextArea {
    func autofocus() -> Self {
        self.add(.init(attribute: "autofocus", value: nil))
    }
}
