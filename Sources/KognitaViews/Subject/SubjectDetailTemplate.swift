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
//            let subjectContext: SubjectCardContext
//            var subject: Subject { return subjectContext.subject }
            let subject: Subject
            let subjectLevel: User.SubjectLevel
            let topics: [Topic.Response]
            let topicLevels: [TopicCardContext]
//            let leaderboard: [(rank: WorkPoints.LeaderboardRank, isBold: Bool)]

            public init(user: User, subject: Subject, topics: [Topic.Response], levels: [User.TopicLevel], subjectLevel: User.SubjectLevel, leaderboard: [WorkPoints.LeaderboardRank]) {
                self.user = user
                self.base = .init(title: subject.name, description: subject.name)
                self.subject = subject
                self.subjectLevel = subjectLevel
                self.topics = topics
                self.topicLevels = topics.map { response in
                    return .init(topic: response.topic, level: levels.first(where: { $0.topicID == response.topic.id }))
                }
//                self.leaderboard = leaderboard.map { ($0, $0.userID == user.id) }
            }
        }

        public init() {}

        public let context: RootValue<Context> = .root()

        public var body: View {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: context.base,
                content:
                Row {
                    Div {
                        Div {
                            Div {
                                OrderdList {
                                    ListItem {
                                        Anchor {
                                            "localize(.subjectsTitle)"
                                        }
                                        .href("../subjects")
                                    }
                                    .class("breadcrumb-item")
                                    ListItem {
                                        context.subject.name
                                    }
                                    .class("breadcrumb-item active")
                                }
                                .class("breadcrumb")
                                .margin(.zero)
                            }
                            .class("page-title-right")
                            H4 {
                                context.subject.name
                            }
                            .class("page-title")
                        }
                        .class("page-title-box")
                    }
                    .class("col-12")
                } +
                Row {
                    Div {
                        Anchor {
                            Button {
                                Italic().class("mdi mdi-book-open-variant")
                                " localize(.startSession)"
                            }
                            .type(.button)
                            .class("btn-rounded")
                            .button(style: .primary)
                            .margin(.three, for: .bottom)
                        }
                        .data(for: "toggle", value: "modal")
                        .data(for: "target", value: "#start-practice-session")
                    }
                    .class("col-sm-6")
                }
                .class("mb-2") +
                Row {
                    Div {
                        SubjectCard(
                            subject: context.subject,
                            userLevel: context.subjectLevel
                        )
                    }
                    .class("col-md-12")
                } +
                Row {
                    Div {
                        Div {
                            H4 {
                                "localize(.topicListTitle)"
                            }
                            .class("page-title")
                        }
                        .class("page-title-box")
                    }
                    .class("col-12")
                } +
                Row {
                    IF(context.topics.isEmpty) {
                        Div {
                            H3 {
                                "localize(.noTopics)"
                            }
                            .class("page-title")
                        }
                        .class("page-title-box")
                    }.else {
                        ForEach(in: context.topicLevels) { topic in
                            TopicCard(topic: topic)
                        }
                    }
                },

                scripts: [
                    Script().source("/assets/js/practice-session-create.js")
                ],
                
                modals:
                PracticeModal(topics: context.topics)
            )
        }

        struct TopicCardContext {
            let topic: Topic
            let level: User.TopicLevel?
        }

        struct TopicCard<T>: StaticView {

            let topic: TemplateValue<T, TopicCardContext>

            var body: View {
                Div {
                    Div {
                        Div {
                            Text {
                                topic.topic.chapter + ". " + topic.topic.name
                            }
                            .class("mt-0")
                            .margin(.zero, for: .top)
                            .style(.heading3)
                        }
                        .class("card-body")

                        IF(topic.level.isDefined) {
                            UnorderdList {
                                ListItem {
                                    H5 {
                                        "localize(.progressTitle)"
                                    }
                                    .class("card-title")
                                    .margin(.three, for: .bottom)
                                    P {
                                        topic.level.unsafelyUnwrapped.correctScoreInteger
                                        Span {
                                            topic.level.unsafelyUnwrapped.correctProsentage + "%"
                                        }
                                        .float(.right)
                                    }
                                    .font(style: .bold)
                                    .margin(.two, for: .bottom)

                                    ProgressBar(
                                        currentValue: topic.level.unsafelyUnwrapped.correctProsentage,
                                        valueRange: 0...100
                                    )
                                        .bar(size: .medium)
                                    .modify(if: 0.0..<50.0 ~= topic.level.unsafelyUnwrapped.correctProsentage) {
                                        $0.bar(style: .danger)
                                    }
                                    .modify(if: 50.0..<75.0 ~= topic.level.unsafelyUnwrapped.correctProsentage) {
                                        $0.bar(style: .warning)
                                    }
                                    .modify(if: 75.0...100.0 ~= topic.level.unsafelyUnwrapped.correctProsentage) {
                                        $0.bar(style: .success)
                                    }
                                }
                                .class("list-group-item")
                                .padding(.three)
                            }
                            .class("list-group list-group-flush")
                        }
                    }
                    .class("card")
                    .display(.block)
                }
                .class("col-md-6 col-lg-4")
            }
        }

        struct SubjectCardContext {
            let subject: Subject
            let level: User.SubjectLevel
        }

        struct SubjectCard<T>: StaticView {

            let subject: TemplateValue<T, Subject>
            let userLevel: TemplateValue<T, User.SubjectLevel>

            var body: View {
                Div {
                    Div {
                        Text {
                            subject.name
                        }
                        .text(color: .dark)
                        .margin(.zero, for: .top)
                        .style(.heading2)

                        Text {
                            subject.description
                                .escaping(.unsafeNone)
                        }
                        .class("font-13")
                        .text(color: .muted)
                        .margin(.three, for: .bottom)
                        .style(.paragraph)
                    }
                    .class("card-body")

                    UnorderdList {
                        ListItem {
                            Text {
                                "Totalt fullførte oppgaver"
                            }
                            .class("card-title")
                            .margin(.three, for: .bottom)
                            .style(.heading5)
                            Text {
                                userLevel.correctScoreInteger
                                Span {
                                    userLevel.correctProsentage + "%"
                                }
                                .float(.right)
                            }
                            .style(.paragraph)
                            .font(style: .bold)
                            .margin(.two, for: .bottom)

                            ProgressBar(
                                currentValue: userLevel.correctProsentage,
                                valueRange: 0...100
                            )
                                .bar(size: .medium)
                            .modify(if: 0.0..<50.0 ~= userLevel.correctProsentage) {
                                $0.bar(style: .danger)
                            }
                            .modify(if: 50.0..<75.0 ~= userLevel.correctProsentage) {
                                $0.bar(style: .warning)
                            }
                            .modify(if: 75.0...100.0 ~= userLevel.correctProsentage) {
                                $0.bar(style: .success)
                            }
                        }
                        .class("list-group-item")
                        .padding(.three)
                    }
                    .class("list-group list-group-flush")
                }
                .class("card")
                .display(.block)
            }
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
