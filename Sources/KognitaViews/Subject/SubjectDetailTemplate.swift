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

            public init(user: User, subject: Subject, topics: [[Topic]], levels: [User.TopicLevel], subjectLevel: User.SubjectLevel, leaderboard: [WorkPoints.LeaderboardRank]) {
                self.user = user
                self.base = .init(title: subject.name, description: subject.name)
                self.subject = subject
                self.subjectLevel = subjectLevel
                self.topicLevels = topics.map { topics in
                    topics.map { topic in
                        .init(topic: topic, level: levels.first(where: { $0.topicID == topic.id }))
                    }
                }
            }
        }

        public init() {}

        public let context: RootValue<Context> = .root()

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
            .scripts {
                Script().source("/assets/js/practice-session-create.js")
            }
        }

        struct TopicLevels<T>: HTMLComponent {

            let levels: TemplateValue<T, [[TopicCardContext]]>

            var body: HTML {
                ForEach(enumerated: levels) { topics, index in
                    Div {
                        Div {
                            title(index)
                        }
                        .class("page-title-box")
                    }
                    .class("col-12")
                    .margin(.three, for: .top)

                    ForEach(in: topics) { topic in
                        TopicCard(topic: topic)
                    }
                }
            }

            func title(_ index: RootValue<Int>) -> HTML {
                Text {
                    "Nivå "
                    index.map { value in
                        value + 1
                    }
                }
                .class("page-title")
                .style(.heading4)
            }
        }

        struct TopicCardContext {
            let topic: Topic
            let level: User.TopicLevel?
        }

        struct TopicCard<T>: HTMLComponent {

            let topic: TemplateValue<T, TopicCardContext>

            var body: HTML {
                Div {
                    Card {
                        Text {
                            topic.topic.chapter + ". " + topic.topic.name
                        }
                        .margin(.zero, for: .top)
                        .style(.heading3)

                        Button {
                            Italic().class("mdi mdi-book-open-variant")
                            " "
                            Localized(key: Strings.subjectStartSession)
                        }
                        .type(.button)
                        .class("btn-rounded")
                        .button(style: .light)
                        .margin(.one, for: .vertical)
                    }
                    .sub {
                        IF(isDefined: topic.level) { level in
                            TopicLevel(
                                level: level
                            )
                        }
                    }
                    .display(.block)
                }
                .class("col-md-6 col-lg-4")
                .on(click: "startPracticeSession([" + topic.topic.id + "], " + topic.topic.subjectId + ")")
            }
        }

        struct TopicLevel<T>: HTMLComponent {

            let level: TemplateValue<T, User.TopicLevel>

            var body: HTML {
                UnorderdList {
                    ListItem {
                        Text {
                            level.correctProsentage + "%"
                            Small { level.correctScoreInteger + " riktig" }
                                .margin(.one, for: .left)

                        }
                        .font(style: .bold)
                        .margin(.two, for: .bottom)

                        KognitaProgressBar(value: level.correctProsentage)
                    }
                    .class("list-group-item")
                    .padding(.three)
                }
                .class("list-group list-group-flush")
            }
        }

        struct SubjectCardContext {
            let subject: Subject
            let level: User.SubjectLevel
        }

        struct SubjectCard<T>: HTMLComponent {

            let subject: TemplateValue<T, Subject>
            let userLevel: TemplateValue<T, User.SubjectLevel>
            let topicIDsJSList: TemplateValue<T, String>

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
                        Localized(key: Strings.subjectStartSession)
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
    }
}

struct KognitaProgressBadge<T>: HTMLComponent {

    let value: TemplateValue<T, Double>

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

struct KognitaProgressBar<T>: HTMLComponent {

    let value: TemplateValue<T, Double>

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
