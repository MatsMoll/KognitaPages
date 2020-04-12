import BootstrapKit

struct KognitaProgressBadge: HTMLComponent {

    let value: TemplateValue<Double>

    var body: HTML {
        Badge {
            value + "%"
        }
        .float(.right)
        .modify(if: 0.0..<40.0 ~= value) {
            $0.background(color: .danger)
        }
        .modify(if: 40.0..<75.0 ~= value) {
            $0.background(color: .warning)
        }
        .modify(if: 75.0...100.0 ~= value) {
            $0.background(color: .success)
        }
    }
}
