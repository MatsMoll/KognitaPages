//
//  SubjectDetailTopicCard.swift
//  KognitaViews
//
//  Created by Mats Mollestad on 10/12/2019.

import BootstrapKit
import KognitaCore

extension Subject.Templates.Details {

    struct TopicList: HTMLComponent {

        @TemplateValue([Topic.UserOverview].self)
        var topics

        @TemplateValue(Subject.ID?.self)
        var subjectID

        @TemplateValue(Bool.self)
        var canPractice

        var body: HTML {
            ForEach(in: topics) { topic in
                TopicCard(
                    topic: topic,
                    subjectID: subjectID,
                    canPractice: canPractice
                )
            }
        }
    }

    struct TopicCard: HTMLComponent {

        @TemplateValue(Topic.UserOverview.self)
        var topic

        @TemplateValue(Subject.ID?.self)
        var subjectID

        @TemplateValue(Bool.self)
        var canPractice

        var body: HTML {
            Div {
                Card {
                    Text {
                        topic.name
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
                    .isRounded()
                    .button(style: .light)
                    .margin(.one, for: .vertical)
                    .isDisabled(canPractice == false)
                }
                .footer {
                    Competence(competence: topic.competence)
                }
                .modifyFooter {
                    $0.padding(.zero)
                }
                .display(.block)
            }
            .column(width: .six, for: .medium)
            .column(width: .twelve)
            .on(click: "startPracticeSessionWithTopicIDs([" + topic.id + "], " + subjectID + ")")
        }
    }

    struct Competence: HTMLComponent {

        @TemplateValue(CompetenceData.self)
        var competence

        var body: HTML {
            UnorderedList {
                ListItem {
                    Text {
                        competence.percentage + "%"
                        Small { competence.userScore + " riktig" }
                            .margin(.one, for: .left)

                    }
                    .font(style: .bold)
                    .margin(.two, for: .bottom)

                    KognitaProgressBar(value: competence.percentage)
                }
                .class("list-group-item")
                .padding(.three)
            }
            .class("list-group list-group-flush")
        }
    }
}
