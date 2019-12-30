//
//  SubjectDetailTemplate.swift
//  App
//
//  Created by Mats Mollestad on 26/02/2019.
//
// swiftlint:disable line_length nesting

import BootstrapKit
import KognitaCore

extension Subject.Templates {
    public struct Details: HTMLTemplate {

        public struct Context {
            let base: BaseTemplateContent
            let user: User
            let subject: Subject
            let subjectLevel: User.SubjectLevel
//            let topics: [Topic.Response]
            let topicLevels: [[TopicCardContext]]
            var topicIDsJSList: String {
                "[\(topicLevels.flatMap { $0 }.compactMap { $0.topic.id }.reduce("") { $0 + "\($1), " }.dropLast(2))]"
            }

            public init(
                user: User,
                details: Subject.Details
            ) {
                self.user = user
                self.base = .init(title: details.subject.name, description: details.subject.name)
                self.subject = details.subject
                self.subjectLevel = details.subjectLevel
                self.topicLevels = [details.topics.map { topic in
                    TopicCardContext(
                        topic: topic.topic,
                        level: details.levels.first(where: { $0.topicID == topic.topic.id }),
                        numberOfTasks: topic.taskCount
                    )
                }]
            }
        }

        public init() {}

        public let context: TemplateValue<Context> = .root()

        let breadcrumbs: [BreadcrumbItem] = [
            BreadcrumbItem(link: "../subjects", title: .init(view: Localized(key: Strings.subjectTitle)))
        ]

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: context.base
            ) {
                PageTitle(
                    title: context.subject.name,
                    breadcrumbs: breadcrumbs
                )
                Row {
                    Div {
                        SubjectCard(
                            subject: context.subject,
                            userLevel: context.subjectLevel,
                            topicIDsJSList: context.topicIDsJSList
                        )
                        Row {
                            IF(context.topicLevels.isEmpty) {
                                Div {
                                    Text(Strings.subjectsNoTopics)
                                        .class("page-title")
                                        .style(.heading3)
                                }
                                .class("page-title-box")
                            }.else {
                                TopicLevels(
                                    levels: context.topicLevels
                                )
                            }
                        }
                    }
                    .column(width: .eight, for: .large)
                    Div {
                        StatisticsCard()
                        IF(context.user.isCreator) {
                            CreateContentCard()
                        }
                    }
                    .column(width: .four, for: .large)
                }
            }
            .scripts {
                Script().source("/assets/js/vendor/Chart.bundle.min.js")
                Script().source("/assets/js/results/weekly-histogram.js")
                Script().source("/assets/js/practice-session-create.js")
            }
            .modals {
                IF(context.user.isCreator) {
                    CreateContentModal(
                        subject: context.subject
                    )
                }
            }
        }

        struct SubjectCardContext {
            let subject: Subject
            let level: User.SubjectLevel
        }

        struct SubjectCard: HTMLComponent {

            let subject: TemplateValue<Subject>
            let userLevel: TemplateValue<User.SubjectLevel>
            let topicIDsJSList: TemplateValue<String>

            var body: HTML {
                Card {
//                    KognitaProgressBadge(value: userLevel.correctProsentage)

                    Text { subject.name }
                        .text(color: .dark)
                        .margin(.zero, for: .top)
                        .style(.heading2)

                    Button {
                        Italic().class("mdi mdi-book-open-variant")
                        " "
                        Strings.subjectStartSession.localized()
                    }
                    .type(.button)
                    .class("btn-rounded")
                    .button(style: .primary)
                    .margin(.three, for: .bottom)
                    .on(click: "startPracticeSession(" + topicIDsJSList + ", " + subject.id + ")")

                    Text {
                        subject.description
                            .escaping(.unsafeNone)
                    }
                    .class("font-13")
                    .text(color: .muted)
                    .margin(.three, for: .bottom)
                    .style(.paragraph)
                }
                .sub {
                    UnorderdList {
                        ListItem {
                            Text {
                                userLevel.correctProsentage + "%"
                                Small { userLevel.correctScoreInteger }
                                    .margin(.one, for: .left)
                            }
                            .style(.paragraph)
                            .font(style: .bold)
                            .margin(.two, for: .bottom)

                            KognitaProgressBar(value: userLevel.correctProsentage)
                        }
                        .class("list-group-item")
                        .padding(.three)
                    }
                    .class("list-group list-group-flush")
                }
                .display(.block)
            }
        }

        struct CreateContentCard: HTMLComponent {

            var body: HTML {
                Card {
                    Text {
                        "Lag innhold"
                    }
                    .style(.heading3)
                    .text(color: .dark)

                    Anchor {
                        "Foreslå innhold"
                    }
                    .href("#")
                    .button(style: .light)
                    .class("btn-rounded")
                    .toggle(modal: .id("create-content-modal"))
                }
            }
        }

        struct StatisticsCard: HTMLComponent {

            var body: HTML {
                Card {
                    Text {
                        "Statistikk"
                    }
                    .style(.heading3)
                    .text(color: .dark)
                    .margin(.two, for: .bottom)

                    Text {
                        "Timer øvd de siste ukene:"
                    }
                    Div {
                        Canvas().id("practice-time-histogram")
                    }
                    .class("mt-3 chartjs-chart")
                }
            }
        }
    }
}

struct KognitaProgressBadge: HTMLComponent {

    let value: TemplateValue<Double>

    var body: HTML {
        Badge {
            value + "%"
        }
        .float(.right)
        .modify(if: 0.0..<50.0 ~= value) {
            $0.background(color: .danger)
        }
        .modify(if: 50.0..<75.0 ~= value) {
            $0.background(color: .warning)
        }
        .modify(if: 75.0...100.0 ~= value) {
            $0.background(color: .success)
        }
    }
}

struct KognitaProgressBar: HTMLComponent {

    let value: TemplateValue<Double>

    var body: HTML {
        ProgressBar(
            currentValue: value,
            valueRange: 0...100
        )
            .bar(size: .medium)
        .modify(if: 0.0..<50.0 ~= value) {
            $0.bar(style: .danger)
        }
        .modify(if: 50.0..<75.0 ~= value) {
            $0.bar(style: .warning)
        }
        .modify(if: 75.0...100.0 ~= value) {
            $0.bar(style: .success)
        }
    }
}

extension AttributeNode {

    func toggle(modal id: HTMLIdentifier) -> Self {
        self.data(for: "toggle", value: "modal")
            .data(for: "target", value: id)
    }
}
