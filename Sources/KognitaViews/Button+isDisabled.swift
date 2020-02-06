import BootstrapKit

extension Button {
    func isDisabled(_ condition: Conditionable) -> Button {
        self.modify(if: condition) {
            $0.add(HTMLAttribute(attribute: "disabled", value: nil))
        }
    }
}
