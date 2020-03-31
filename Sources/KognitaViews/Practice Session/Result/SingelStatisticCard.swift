
import BootstrapKit

struct SingleStatisticCardContent {
    let title: String
    let mainContent: String
}

struct SingleStatisticCard: HTMLComponent, AttributeNode {

    let title: HTML
    let mainContent: HTML
    
    var attributes: [HTMLAttribute] = []

    var body: HTML {
        Card {
            Text { title }
                .text(color: .muted)

            Text { mainContent }
                .text(color: .dark)
                .style(.lead)
                .font(style: .bold)

//            IF(extraContent != nil) {
//                Text { extraContent ?? "" }
//                    .text(color: .muted)
//            }
        }
        .add(attributes: attributes)
    }

    func copy(with attributes: [HTMLAttribute]) -> SingleStatisticCard {
        .init(title: title, mainContent: mainContent, attributes: attributes)
    }
}
