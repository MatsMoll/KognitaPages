//
//  SubjectDetailTopicCard.swift
//  KognitaViews
//
//  Created by Mats Mollestad on 10/12/2019.
// swiftlint:disable line_length nesting

import BootstrapKit
import KognitaCore

extension Subject.Templates.Details {
    
    struct TopicLevels: HTMLComponent {

        let levels: TemplateValue<[[TopicCardContext]]>

        var body: HTML {
            ForEach(enumerated: levels) { topics, index in
                Div {
                    Div {
                        title(index)
                    }
                    .class("page-title-box")
                }
                .column(width: .twelve)

                ForEach(in: topics) { topic in
                    TopicCard(topic: topic)
                }
            }
        }

        func title(_ index: TemplateValue<Int>) -> HTML {
            Text {
                "Nivå "
                index
//                index.map { value in
//                    value + 1
//                }
            }
            .class("page-title")
            .style(.heading4)
        }
    }

    struct TopicCardContext {
        let topic: Topic
        let level: User.TopicLevel?
        let numberOfTasks: Int
    }

    struct TopicCard: HTMLComponent {

        let topic: TemplateValue<TopicCardContext>

        var body: HTML {
            Div {
                Card {
                    Text {
                        topic.topic.name
                    }
                    .margin(.zero, for: .top)
                    .style(.heading3)

                    Small {
                        "Antall oppgaver: "
                        topic.numberOfTasks
                    }
                    .display(.block)

                    Button {
                        Italic().class("mdi mdi-book-open-variant")
                        " "
                        Strings.subjectStartSession.localized()
                    }
                    .type(.button)
                    .class("btn-rounded")
                    .button(style: .light)
                    .margin(.one, for: .vertical)
                }
                .sub {
                    Unwrap(topic.level) { level in
                        TopicLevel(
                            level: level
                        )
                    }
                }
                .display(.block)
            }
            .column(width: .six, for: .medium)
            .column(width: .twelve)
            .on(click: "startPracticeSession([" + topic.topic.id + "], " + topic.topic.subjectId + ")")
        }
    }

    struct TopicLevel: HTMLComponent {

        let level: TemplateValue<User.TopicLevel>

        var body: HTML {
            UnorderedList {
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
}
