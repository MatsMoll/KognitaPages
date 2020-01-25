import BootstrapKit

struct KognitaProgressBar: HTMLComponent, AttributeNode {

    var attributes: [HTMLAttribute]
    let value: TemplateValue<Double>

    init(value: TemplateValue<Double>) {
        self.value = value
        self.attributes = []
    }

    private init(value: TemplateValue<Double>, attributes: [HTMLAttribute]) {
        self.value = value
        self.attributes = attributes
    }

    var body: HTML {
        ProgressBar(
            currentValue: value,
            valueRange: 0...100
        )
            .bar(size: .medium)
            .add(attributes: attributes)
        .modify(if: 0.0..<50.0 ~= value) {
            $0.bar(style: .danger)
        }
        .modify(if: 50.0..<75.0 ~= value) {
            $0.bar(style: .warning)
        }
        .modify(if: 75.0...100.0 ~= value) {
            $0.bar(style: .success)
        }
    }

    func copy(with attributes: [HTMLAttribute]) -> KognitaProgressBar {
        .init(value: value, attributes: attributes)
    }
}

