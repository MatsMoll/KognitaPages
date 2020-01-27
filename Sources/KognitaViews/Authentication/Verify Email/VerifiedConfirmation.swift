import BootstrapKit
import KognitaCore


extension User.Templates {
    public struct VerifiedConfirmation: HTMLPage {

        public init() {}

        public var body: HTML {
            BaseTemplate(
                context: .init(
                    title: "Epost verifisert",
                    description: "Eposten din er nå verifisert"
                )
            ) {
                KognitaNavigationBar()
                Container {
                    Text {
                        "Du har nå verifisert eposten din"
                    }
                    .style(.heading2)
                    .text(color: .dark)
                }
            }
        }
    }
}
