import BootstrapKit
import KognitaCore
import Foundation

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

    var editUri: String {
        "/subject-tests/\(id)/edit"
    }
}

extension SubjectTest.ListReponse {
    var containsTests: Bool {
        !(finnishedTests.isEmpty && unopenedTests.isEmpty && ongoingTests.isEmpty)
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
                BreadcrumbItem(
                    link: "/subjects",
                    title: "Fagoversikt"
                ),
                BreadcrumbItem(
                    link: ViewWrapper(view: "/subjects/" + context.list.subject.id),
                    title: ViewWrapper(view: context.list.subject.name)
                )
            ]
        }

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Prøver", description: "Prøver"))
            ) {
                PageTitle(title: "Prøver", breadcrumbs: breadcrumbs)

                ContentStructure {

                    IF(context.list.containsTests) {
                        SubjectTestList(list: context.list)
                    }.else {
                        Text {
                            "Det finnes ingen prøver ennå."
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

    struct SubjectTestList: HTMLComponent {

        let list: TemplateValue<SubjectTest.ListReponse>

        var body: HTML {
            NodeList {
                IF(list.ongoingTests.isEmpty == false) {
                    Text {
                        "Pågående prøver"
                    }
                    .style(.heading3)

                    Row {
                        ForEach(in: list.ongoingTests) { test in
                            SubjectTestCard(test: test)
                        }
                    }
                }
                IF(list.unopenedTests.isEmpty == false) {
                    Text {
                        "Planlagte prøver"
                    }
                    .style(.heading3)

                    Row {
                        ForEach(in: list.unopenedTests) { test in
                            SubjectTestCard(test: test)
                        }
                    }
                }
                IF(list.finnishedTests.isEmpty == false) {
                    Text {
                        "Fullførte prøver"
                    }
                    .style(.heading3)

                    Row {
                        ForEach(in: list.finnishedTests) { test in
                            SubjectTestCard(test: test)
                        }
                    }
                }
            }
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

                    SubjectTestCardActions(test: test)
                }
            }
            .column(width: .six, for: .large)
            .column(width: .twelve)
        }

        struct SubjectTestCardActions: HTMLComponent {

            let test: TemplateValue<SubjectTest.OverviewResponse>

            var body: HTML {
                Unwrap(test.endsAt) { (endsAt: TemplateValue<Date>) in
                    IF(test.isOpen) {
                        Text {
                            "Slutter: "
                            endsAt.style(date: .short, time: .medium)
                        }

                        Anchor {
                            "Se status i sanntid"
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

                        Button {
                            "Gjenåpne prøve"
                        }
                        .button(style: .light)
                        .on(click: test.openCall)
                        .margin(.one, for: .left)
                    }
                }
                .else {
                    Button {
                        "Åpne prøve"
                    }
                    .button(style: .light)
                    .on(click: test.openCall)

                    Anchor {
                        "Rediger"
                    }
                    .button(style: .light)
                    .margin(.one, for: .left)
                    .href(test.editUri)
                }
            }
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
                    "Lag prøve"
                }
                .href("subject-tests/create")
                .button(style: .primary)
            }
        }
    }
}
