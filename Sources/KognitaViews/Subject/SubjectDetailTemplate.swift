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
    public struct Details: TemplateView {

        public struct Context {
            let base: BaseTemplateContent
            let user: User
            let subject: Subject
            let subjectLevel: User.SubjectLevel
            let topics: [Topic.Response]
            let topicLevels: [TopicCardContext]
            var topicIDsJSList: String {
                "[\(topics.compactMap { $0.topic.id }.reduce("") { $0 + "\($1), " }.dropLast(2))]"
            }

            public init(user: User, subject: Subject, topics: [Topic.Response], levels: [User.TopicLevel], subjectLevel: User.SubjectLevel, leaderboard: [WorkPoints.LeaderboardRank]) {
                self.user = user
                self.base = .init(title: subject.name, description: subject.name)
                self.subject = subject
                self.subjectLevel = subjectLevel
                self.topics = topics
                self.topicLevels = topics.map { response in
                    return .init(topic: response.topic, level: levels.first(where: { $0.topicID == response.topic.id }))
                }
            }
        }

        public init() {}

        public let context: RootValue<Context> = .root()

        let breadcrumbs: [BreadcrumbItem] = [
            BreadcrumbItem(link: "../subjects", title: .init(view: Localized(key: Strings.subjectTitle)))
        ]

        public var body: View {
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
                    Div {
                        Div {
                            Text(Strings.subjectTopicListTitle)
                                .class("page-title")
                                .style(.heading4)
                        }
                        .class("page-title-box")
                    }
                    .class("col-12")
                }
                Row {
                    IF(context.topics.isEmpty) {
                        Div {
                            Text(Strings.subjectsNoTopics)
                                .class("page-title")
                                .style(.heading3)
                        }
                        .class("page-title-box")
                    }.else {
                        ForEach(in: context.topicLevels) { topic in
                            TopicCard(topic: topic)
                        }
                    }
                }
            }
            .scripts {
                Script().source("/assets/js/practice-session-create.js")
            }
        }

        struct TopicCardContext {
            let topic: Topic
            let level: User.TopicLevel?
        }

        struct TopicCard<T>: StaticView {

            let topic: TemplateValue<T, TopicCardContext>

            var body: View {
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
                        IF(topic.level.isDefined) {
                            UnorderdList {
                                ListItem {
                                    Text {
                                        topic.level.unsafelyUnwrapped.correctProsentage + "%"
                                        Small { topic.level.unsafelyUnwrapped.correctScoreInteger + " riktig" }
                                            .margin(.one, for: .left)

                                    }
                                    .font(style: .bold)
                                    .margin(.two, for: .bottom)

                                    KognitaProgressBar(value: topic.level.unsafelyUnwrapped.correctProsentage)
                                }
                                .class("list-group-item")
                                .padding(.three)
                            }
                            .class("list-group list-group-flush")
                        }
                    }
                    .display(.block)
                }
                .class("col-md-6 col-lg-4")
                .on(click: "startPracticeSession([" + topic.topic.id + "], " + topic.topic.subjectId + ")")
            }
        }

        struct SubjectCardContext {
            let subject: Subject
            let level: User.SubjectLevel
        }

        struct SubjectCard<T>: StaticView {

            let subject: TemplateValue<T, Subject>
            let userLevel: TemplateValue<T, User.SubjectLevel>
            let topicIDsJSList: TemplateValue<T, String>

            var body: View {
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

struct KognitaProgressBadge<T>: StaticView {

    let value: TemplateValue<T, Double>

    var body: View {
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

struct KognitaProgressBar<T>: StaticView {

    let value: TemplateValue<T, Double>

    var body: View {
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

//
//
//extension SubjectDetailTemplate {
//
//    struct Leaderboard: ContextualTemplate {
//        typealias Context = [(rank: WorkPoints.LeaderboardRank, isBold: Bool)]
//
//        func build() -> CompiledTemplate {
//            return div.class("card").child(
//                div.class("card-body").child(
//                    div.class("inbox-widget").child(
//                        h4.class("header-title mb-3").child(
//                            "Leaderboard"
//                        ),
//                        forEach(render: LeaderboardRow())
//                    )
//                )
//            )
//        }
//    }
//
//    struct LeaderboardRow: ContextualTemplate {
//        typealias Context = (rank: WorkPoints.LeaderboardRank, isBold: Bool)
//
//        func build() -> CompiledTemplate {
//            return div.class("inbox-item").child(
//                div.class("inbox-item-img").child(
//                    img.src("/assets/images/users/avatar-2.jpg").class("rounded-circle")
//                ),
//                p.class("inbox-item-author").addDynamic(.class("font-weight-bold"), with: \.isBold == true).child(
//                    variable(\.rank.rank) + ". " + variable(\.rank.userName)
//                ),
//                p.class("inbox-item-text").child(
//                    variable(\.rank.pointsSum) + " Arbeidspoeng"
//                )
//            )
//        }
//    }
//}
