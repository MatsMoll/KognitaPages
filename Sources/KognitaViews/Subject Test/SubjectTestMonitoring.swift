import BootstrapKit
import Foundation

extension SubjectTest.Templates {

    public struct Monitor: HTMLTemplate {

        public struct Context {
            let user: User
            let test: SubjectTest
            var renderedAt: Date { .now }

            public init(user: User, test: SubjectTest) {
                self.user = user
                self.test = test
            }
        }

        public init() {}

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Oversikt", description: "Oversikt", showCookieMessage: false))
            ) {
                PageTitle(title: context.test.title)

                Unwrap(context.test.endedAt) { endsAt in
                    Input()
                        .value(endsAt.iso8601)
                        .id("ends-at")
                        .type(.hidden)
                }

                Input()
                    .value(context.renderedAt.iso8601)
                    .id("rendered-at")
                    .type(.hidden)

                ContentStructure {
                    Row { "" }.id("user-status")
                }
                .secondary {
                    Row {
                        Div {
                            Card {
                                Text {
                                    "Tid igjen "
                                }
                                .text(color: .secondary)

                                Text {
                                    Span().id("time-left")
                                }
                                .style(.heading3)
                                .text(color: .dark)
                            }

                            Card {
                                Text {
                                    "Passord"
                                }
                                .text(color: .secondary)

                                Text {
                                    context.test.password
                                }
                                .style(.heading3)
                                .text(color: .dark)
                            }

                            Card {
                                Text {
                                    "Handlinger"
                                }
                                .style(.heading3)
                                .text(color: .dark)

                                Form {
                                    Button {
                                        "Stopp prøve"
                                    }
                                    .button(style: .danger)
                                    .type(.submit)
                                }
                                .method(.post)
                                .action("end")
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
