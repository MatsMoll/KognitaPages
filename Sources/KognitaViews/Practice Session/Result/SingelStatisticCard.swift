
import BootstrapKit

struct SingleStatisticCardContent {
    let title: String
    let mainContent: String
    let extraContent: String?
}

struct SingleStatisticCard: HTMLComponent, AttributeNode {

    let stats: TemplateValue<SingleStatisticCardContent>
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

    func copy(with attributes: [HTMLAttribute]) -> SingleStatisticCard {
        .init(stats: stats, attributes: attributes)
    }
}


struct Unwrap: HTMLComponent {

    let body: HTML

    init<V>(value: TemplateValue<V?>, @HTMLBuilder build: (TemplateValue<V>) -> HTML) {
        body = IF(isDefined: value, content: build)
    }
}
