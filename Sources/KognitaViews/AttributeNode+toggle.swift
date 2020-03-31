import HTMLKit

extension AttributeNode {

    func toggle(modal id: HTMLIdentifier) -> Self {
        self.data(for: "toggle", value: "modal")
            .data(for: "target", value: id)
    }
}
