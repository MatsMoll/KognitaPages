
import BootstrapKit

struct SingleStatisticCardContent {
    let title: String
    let mainContent: String
    let extraContent: String?
}

struct SingleStatisticCard<T>: HTMLComponent, AttributeNode {

    let stats: TemplateValue<T, SingleStatisticCardContent>
    var attributes: [HTMLAttribute] = []

    var body: HTML {
        Card {
            Text {
                stats.title
            }
            .text(color: .muted)

            Text {
                stats.mainContent
            }
            .text(color: .dark)
            .style(.lead)
            .font(style: .bold)

            Text {
                stats.extraContent
            }
            .text(color: .muted)

            Unwrap(value: stats.extraContent) { extraContent in
                Text {
                    extraContent
                }
                .text(color: .muted)
            }
        }
        .add(attributes: attributes)
    }

    func copy(with attributes: [HTMLAttribute]) -> SingleStatisticCard<T> {
        .init(stats: stats, attributes: attributes)
    }
}


struct Unwrap: HTMLComponent {

    let body: HTML

    init<T, V>(value: TemplateValue<T, V?>, @HTMLBuilder build: (TemplateValue<T, V>) -> HTML) {
        body = IF(isDefined: value, content: build)
    }
}
