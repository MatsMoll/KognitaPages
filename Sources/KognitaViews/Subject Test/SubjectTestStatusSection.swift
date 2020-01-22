import BootstrapKit
import KognitaCore

extension SubjectTest.Templates {
    public struct StatusSection: HTMLTemplate {

        public typealias Context = SubjectTest.CompletionStatus

        public init() {}

        public var body: HTML {
            NodeList {
                Div {
                    Card {
                        Text {
                            "Antall som har åpnet"
                        }
                        .text(color: .secondary)

                        Text {
                            context.amountOfEnteredUsers
                        }
                        .style(.heading3)
                        .text(color: .dark)
                    }
                }
                .column(width: .six, for: .large)
                Div {
                    Card {
                        Text {
                            "Antall fullført"
                        }
                        .text(color: .secondary)

                        Text {
                            context.amountOfCompletedUsers
                        }
                        .style(.heading3)
                        .text(color: .dark)
                    }
                }
                .column(width: .six, for: .large)
            }
        }
    }
}
