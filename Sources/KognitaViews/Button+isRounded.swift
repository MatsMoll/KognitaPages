import BootstrapKit

extension Button {
    public func isRounded(_ condtion: Conditionable = true) -> Button {
        self.modify(if: condtion) {
            $0.class("btn-rounded")
        }
    }
}
