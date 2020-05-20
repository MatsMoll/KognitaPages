import BootstrapKit

struct SingleStatisticCardContent {
    let title: String
    let mainContent: String
    let details: String?
}

struct SingleStatisticCard: HTMLComponent, AttributeNode {

    let title: HTML
    let mainContent: HTML
    let moreDetails: TemplateValue<String?>

    var attributes: [HTMLAttribute] = []

    var body: HTML {
        Card {
            Text { title }
                .text(color: .muted)

            Text { mainContent }
                .text(color: .dark)
                .style(.lead)
                .font(style: .bold)

            Unwrap(moreDetails) { details in
                Text { details }
                    .text(color: .muted)
            }
        }
        .add(attributes: attributes)
    }

    func copy(with attributes: [HTMLAttribute]) -> SingleStatisticCard {
        .init(title: title, mainContent: mainContent, moreDetails: moreDetails, attributes: attributes)
    }
}
