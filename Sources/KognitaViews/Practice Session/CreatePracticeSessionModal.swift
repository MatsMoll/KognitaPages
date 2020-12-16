//
//  CreatePracticeSessionModel.swift
//  KognitaViews
//
//  Created by Mats Mollestad on 25/10/2020.
//

import Foundation

extension PracticeSession.Templates {

    /// A modal used to create practice sessions
    struct CreateModal: HTMLComponent {

        static let modalID = "practice-session-create-modal"
        static let sessionTopicID = "session-topic-id"
        static let sessionTopicName = "session-topic-name"
        static let sessionSubjectID = "session-subject-id"
        static let useMultipleChoiceTasksID = "use-multiple-choice"
        static let useTypingTasksID = "use-typing-tasks"
        static let numberOfTasksGoalID = "number-of-tasks-goal"

        var body: HTML {
            Modal(title: "Start en øving", id: CreateModal.modalID) {

                Text {
                    "Start en øving i "
                    Span().id(CreateModal.sessionTopicName)
                    "."
                }

                Text { "Oppgave typer" }
                    .style(.heading4)
                    .text(color: .dark)

                Row {
                    Div {
                        Div {
                            Input()
                                .type(.checkbox)
                                .class("custom-control-input")
                                .name(CreateModal.useMultipleChoiceTasksID)
                                .id(CreateModal.useMultipleChoiceTasksID)
                                .isChecked(true)

                            Label { "Bruk flervalgsoppgaver" }
                                .class("custom-control-label")
                                .for(CreateModal.useMultipleChoiceTasksID)
                        }
                        .class("custom-control custom-checkbox")
                    }
                    .column(width: .six, for: .large)

                    Div {
                        Div {
                            Input()
                                .type(.checkbox)
                                .class("custom-control-input")
                                .name(CreateModal.useTypingTasksID)
                                .id(CreateModal.useTypingTasksID)
                                .isChecked(true)

                            Label { "Bruk innskrivningsoppgaver" }
                                .class("custom-control-label")
                                .for(CreateModal.useTypingTasksID)
                        }
                        .class("custom-control custom-checkbox")
                    }
                    .column(width: .six, for: .large)
                }

                FormGroup {
                    Input()
                        .type(.number)
                        .value(5)
                        .min(value: 1)
                        .max(value: 999)
                        .id(CreateModal.numberOfTasksGoalID)
                }
                .customLabel {
                    Text { "Antall oppgaver å gjøre" }
                        .style(.heading4)
                        .text(color: .dark)
                }

                Input()
                    .type(.hidden)
                    .id(CreateModal.sessionTopicID)

                Input()
                    .type(.hidden)
                    .id(CreateModal.sessionSubjectID)

                Button {
                    MaterialDesignIcon(.messageReplyText)
                        .margin(.one, for: .right)
                    "Start"
                }
                .button(style: .success)
                .on(click: "createSession()")
            }
            .set(data: CreateModal.sessionSubjectID, type: .input, to: CreateModal.sessionSubjectID)
            .set(data: CreateModal.sessionTopicID, type: .input, to: CreateModal.sessionTopicID)
            .set(data: CreateModal.sessionTopicName, type: .node, to: CreateModal.sessionTopicName)
        }

        static func button(subjectID: HTML, topicID: HTML, topicDescription: HTML, @HTMLBuilder content: () -> HTML) -> Button {
            Button {
                content()
            }
            .toggle(modal: .id(CreateModal.modalID))
            .data(CreateModal.sessionSubjectID, value: subjectID)
            .data(CreateModal.sessionTopicID, value: topicID)
            .data(CreateModal.sessionTopicName, value: topicDescription)
        }

        var scripts: HTML {
            NodeList {
                body.scripts
                Script().source("/assets/js/practice-session-create.js")
                Script {
"""
function createSession() {
var topicIDs = $("#\(CreateModal.sessionTopicID)").val().split(",").map(num => parseInt(num))
console.log(topicIDs);
let subjectID = $("#\(CreateModal.sessionSubjectID)").val()
let numberOfTasksGoal = parseInt($("#\(CreateModal.numberOfTasksGoalID)").val())
let useTypingTasks = document.getElementById("\(CreateModal.useTypingTasksID)").checked
let multipleChoiceTasks = document.getElementById("\(CreateModal.useMultipleChoiceTasksID)").checked
startPracticeSessionWithTopicIDs(topicIDs, subjectID, useTypingTasks, multipleChoiceTasks, numberOfTasksGoal);
}
"""
                }
            }
        }
    }
}
