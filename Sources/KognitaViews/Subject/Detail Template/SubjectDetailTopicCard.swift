//
//  SubjectDetailTopicCard.swift
//  KognitaViews
//
//  Created by Mats Mollestad on 10/12/2019.

import BootstrapKit

extension Subject.Templates.Details {

    struct TopicList: HTMLComponent {

        @TemplateValue([Topic.UserOverview].self)
        var topics

        @TemplateValue(Subject.ID.self)
        var subjectID

        @TemplateValue(Bool.self)
        var canPractice
        
        @TemplateValue(Bool.self)
        var canViewResources

        var body: HTML {
            ForEach(in: topics) { topic in
                TopicCard(
                    topic: topic,
                    subjectID: subjectID,
                    canPractice: canPractice,
                    canViewResources: canViewResources
                )
            }
        }
    }

    struct TopicCard: HTMLComponent {

        @TemplateValue(Topic.UserOverview.self)
        var topic

        @TemplateValue(Subject.ID.self)
        var subjectID

        @TemplateValue(Bool.self)
        var canPractice
        
        @TemplateValue(Bool.self)
        var canViewResources

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

                        Break()

                        Badge {
                            topic.multipleChoiceTaskCount
                            MaterialDesignIcon(.formatListBulleted)
                                .margin(.one, for: .left)
                            " Flervalg"
                        }
                        .background(color: .light)

                        Badge {
                            topic.typingTaskCount
                            MaterialDesignIcon(.messageReplyText)
                                .margin(.one, for: .left)
                            " Innskriving"
                        }
                        .background(color: .light)
                        .margin(.two, for: .left)
                    }
                    .display(.block)
                    .margin(.one, for: .bottom)

                    IF(canPractice) {
                        PracticeSession.Templates.CreateModal.button(
                            subjectID: subjectID,
                            topicID: topic.id,
                            topicDescription: topic.name
                        ) {
                            MaterialDesignIcon(.trophy)
                                .margin(.one, for: .right)
                            Strings.subjectStartSession.localized()
                        }
                        .type(.button)
                        .isRounded()
                        .button(style: .light)
                        .margin(.one, for: .vertical)
                        .margin(.one, for: .right)
                        
                        ResourceListModal.button(
                            topicID: topic.id,
                            topicName: topic.name
                        )
                        .type(.button)
                        .isDisabled(canViewResources == false)
                    }.else {
                        Anchor {
                            MaterialDesignIcon(.trophy)
                                .margin(.one, for: .right)
                            Strings.subjectStartSession.localized()
                        }
                        .isRounded()
                        .button(style: .light)
                        .margin(.one, for: .vertical)
                        .margin(.one, for: .right)
                        .href("/login")
                        
                        ResourceListModal.button(
                            topicID: topic.id,
                            topicName: topic.name
                        )
                        
                        Anchor {
                            MaterialDesignIcon(.openBook)
                                .margin(.one, for: .right)
                            "Se ressurser"
                        }
                        .button(style: .light)
                        .isRounded()
                        .href("/login")
                    }
                    
                }
                .footer {
                    Competence(competence: topic.userLevel)
                }
                .modifyFooter {
                    $0.padding(.zero)
                }
                .display(.block)
            }
            .column(width: .six, for: .medium)
            .column(width: .twelve)
        }
    }

    struct Competence: HTMLComponent {

        @TemplateValue(Topic.UserLevel.self)
        var competence

        var body: HTML {
            UnorderedList {
                ListItem {
                    Text {
                        competence.correctProsentage + "%"
                        Small { competence.correctScoreInteger + " riktig" }
                            .margin(.one, for: .left)

                    }
                    .font(style: .bold)
                    .margin(.two, for: .bottom)

                    KognitaProgressBar(value: competence.correctProsentage)
                }
                .class("list-group-item")
                .padding(.three)
            }
            .class("list-group list-group-flush")
        }
    }
}
