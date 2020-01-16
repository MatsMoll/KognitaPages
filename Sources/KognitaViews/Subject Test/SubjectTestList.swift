import Foundation
import BootstrapKit
import KognitaCore

struct DatePicker: HTMLComponent, AttributeNode, FormInput {

    var attributes: [HTMLAttribute]

    @TemplateValue(Date?.self)
    private var selectedDate

    init() {
        attributes = []
    }

    private init(attributes: [HTMLAttribute], selectedDate: TemplateValue<Date?>) {
        self.attributes = attributes
        self.selectedDate = selectedDate
    }

    var body: HTML {
        Input()
            .type(.text)
            .class("date")
            .data("toggle", value: "date-picker")
            .data("single-date-picker", value: true)
            .add(attributes: attributes)
            .modify(if: selectedDate.isDefined) {
                $0.data("start-date", value: selectedDate.formatted(string: "MM/dd/yyyy"))
        }
    }

    func copy(with attributes: [HTMLAttribute]) -> DatePicker {
        .init(attributes: attributes, selectedDate: selectedDate)
    }

    func selected(date: TemplateValue<Date>) -> DatePicker {
        .init(attributes: attributes, selectedDate: date.makeOptional())
    }
}

extension SubjectTest.OverviewResponse {
    var openCall: String {
        "openTest(\(id))"
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
                        Text {
                            "Slutter: "
                            endsAt.style(date: .short, time: .full)
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
                    "Lag en test"
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
