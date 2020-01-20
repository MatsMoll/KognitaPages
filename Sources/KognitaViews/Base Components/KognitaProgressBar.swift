import BootstrapKit

struct KognitaProgressBar: HTMLComponent {

    let value: TemplateValue<Double>

    var body: HTML {
        ProgressBar(
            currentValue: value,
            valueRange: 0...100
        )
            .bar(size: .medium)
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
}
