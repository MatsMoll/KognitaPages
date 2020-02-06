import BootstrapKit

extension Script {
    init(source: String) {
        self.init()
        attributes = [
            HTMLAttribute(attribute: "src", value: source),
            HTMLAttribute(attribute: "type", value: "text/javascript"),
        ]
    }
}
