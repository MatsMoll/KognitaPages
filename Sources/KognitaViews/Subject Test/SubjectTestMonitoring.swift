import BootstrapKit
import KognitaCore


extension SubjectTest.Templates {

    public struct Monitor: HTMLTemplate {

        public struct Context {
            let user: User
            let test: SubjectTest

            public init(user: User, test: SubjectTest) {
                self.user = user
                self.test = test
            }
        }

        public init() {}

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Oversikt", description: "Oversikt"))
            ) {
                PageTitle(title: context.test.title)
                ContentStructure {
                    Row { "" }.id("user-status")
                }
                .secondary {
                    Row {
                        Div {
                            Card {
                                Text {
                                    "Handlinger"
                                }
                                .style(.heading3)
                                .text(color: .dark)

                                Button {
                                    "Stopp prøve"
                                }
                                .on(click: "alert('Ikke implementer');")
                                .button(style: .danger)
                            }
                        }
                        .column(width: .twelve)
                    }
                }
            }
            .scripts {
                Script(source: "/assets/js/subject-test/monitor.js")
            }
        }
    }
}
