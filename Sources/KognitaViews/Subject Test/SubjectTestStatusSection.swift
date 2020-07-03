import BootstrapKit

extension SubjectTest.Templates {
    public struct StatusSection: HTMLTemplate {

        public typealias Context = SubjectTest.CompletionStatus

        public init() {}

        public var body: HTML {
            NodeList {
                Div {
                    Card {
                        Text {
                            "Antall åpnet"
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
                            "Antall levert"
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
