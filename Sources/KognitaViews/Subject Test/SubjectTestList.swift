import BootstrapKit
import KognitaCore

extension SubjectTest.OverviewResponse {
    var openCall: String {
        "openTest(\(id))"
    }

    var monitorUri: String {
        "/subject-tests/\(id)/monitor"
    }

    var resultUri: String {
        "/subject-tests/\(id)/results"
    }
}

extension SubjectTest.Templates {

    public struct List: HTMLTemplate {

        public struct Context {
            let user: User
            let list: SubjectTest.ListReponse

            public init(user: User, list: SubjectTest.ListReponse) {
                self.user = user
                self.list = list
            }
        }

        public init() {}

        var breadcrumbs: [BreadcrumbItem] {
            [
                .init(
                    link: ViewWrapper(view: "/subjects/" + context.list.subject.id),
                    title: ViewWrapper(view: context.list.subject.name)
                )
            ]
        }

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Tester", description: "Tester"))
            ) {
                PageTitle(title: "Tester", breadcrumbs: breadcrumbs)

                ContentStructure {
                    Text {
                        "Alle tester"
                    }
                    .style(.heading2)

                    Row {
                        IF(context.list.tests.isEmpty) {
                            Text {
                                "Det finnes ingen tester enda."
                            }
                        }.else {
                            ForEach(in: context.list.tests) { test in
                                SubjectTestCard(test: test)
                            }
                        }
                    }
                }
                .secondary {
                    CreateTestCard()
                }
            }.scripts {
                Script().source("/assets/js/subject-test/open.js").type("text/javascript")
            }
            .enviroment(locale: "nb")
        }
    }

    struct SubjectTestCard: HTMLComponent {

        @TemplateValue(SubjectTest.OverviewResponse.self)
        var test

        var body: HTML {
            Div {
                Card {
                    Text {
                        test.title
                    }
                    .style(.heading3)
                    .text(color: .dark)

                    Text {
                        "Planlagt dato: "
                        Bold {
                            test.scheduledAt.style(date: .full, time: .none)
                        }
                    }

                    Unwrap(test.endsAt) { endsAt in
                        IF(test.isOpen) {
                            Text {
                                "Slutter: "
                                endsAt.style(date: .short, time: .medium)
                            }

                            Anchor {
                                "Se sanntid status"
                            }
                            .href(test.monitorUri)
                            .button(style: .light)
                        }
                        .else {
                            Text {
                                "Sluttet: "
                                endsAt.style(date: .short, time: .medium)
                            }

                            Anchor {
                                "Se resultater"
                            }
                            .href(test.resultUri)
                            .button(style: .light)
                        }
                    }
                    .else {
                        Button {
                            "Åpne test"
                        }
                        .button(style: .light)
                        .on(click: test.openCall)
                        
                        Anchor {
                            "Rediger"
                        }
                        .button(style: .light)
                        .margin(.one, for: .left)
                        .href("/subject-tests/" + test.id + "/edit")
                    }
                }
            }
            .column(width: .six)
        }
    }

    struct CreateTestCard: HTMLComponent {

        var body: HTML {
            Card {
                Text {
                    "Lag en prøve"
                }
                .style(.heading3)
                .text(color: .dark)

                Anchor {
                    "Lag test"
                }
                .href("subject-tests/create")
                .button(style: .primary)
            }
        }
    }
}
