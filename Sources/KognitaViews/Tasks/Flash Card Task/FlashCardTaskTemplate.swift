//
//  FlashCardTaskTemplate.swift
//  App
//
//  Created by Mats Mollestad on 31/03/2019.
//

import BootstrapKit
import KognitaCore

extension FlashCardTask {
    public struct Templates {}
}

extension FlashCardTask.Templates {
    public struct Execute: HTMLTemplate {

        public struct Context {
            let taskPreview: TaskPreviewTemplateContext

            var session: PracticeSessionRepresentable? { return taskPreview.session }
            var task: Task { return taskPreview.task }
            var topic: Topic { return taskPreview.topic }
            var hasBeenCompleted: Bool { return taskPreview.lastResult?.sessionId == (try? session?.requireID()) }
            var score: Double? {
                if let score = taskPreview.lastResult?.result.resultScore {
                    return score * 4
                } else {
                    return nil
                }
            }
            var prevAnswer: FlashCardAnswer?

            public init(
                taskPreview: TaskPreviewContent,
                user: UserContent,
                currentTaskIndex: Int,
                practiceProgress: Int,
                session: PracticeSessionRepresentable,
                lastResult: TaskResultContent? = nil,
                prevAnswer: FlashCardAnswer?,
                discussions: [TaskDiscussion.Details]
            ) {
                self.taskPreview = .init(
                    task: taskPreview,
                    user: user,
                    practiceProgress: practiceProgress,
                    session: session,
                    taskPath: "flash-card",
                    currentTaskIndex: currentTaskIndex,
                    lastResult: lastResult,
                    discussions: discussions
                )
                self.prevAnswer = prevAnswer
            }
        }

        public init() {}

        public let context: TemplateValue<Context> = .root()

        public var body: HTML {
            TaskPreviewTemplate(context: context.taskPreview) {
                Card {
                    Label {
                        "Skriv svaret her"
                    }
                    InputGroup {
                        TextArea {
                            Unwrap(context.prevAnswer) { answer in
                                answer.answer
                            }
                        }.id("flash-card-answer")
                    }
                    .invalidFeedback {
                        "Du må angi et svar"
                    }
                    .margin(.two, for: .bottom)

                    Button {
                        Italic().class("mdi mdi-send")
                            .margin(.one, for: .right)

                        Strings.exerciseAnswerButton
                            .localized()
                    }
                    .type(.button)
                    .id("submitButton")
                    .button(style: .success)
                    .margin(.one, for: .right)
                    .on(click: "revealSolution();")
                }
            }
            .underSolutionCard {
                Card {
                    Input()
                        .id("next-task")
                        .type(.hidden)
                        .value(context.taskPreview.nextTaskIndex)
                    Text {
                        "Hvordan gikk det?"
                    }
                    .margin(.one, for: .top)
                    .margin(.three, for: .bottom)
                    .style(.heading4)

                    Row {
                        Div {
                            Text {
                                "Dårlig"
                            }
                            .text(alignment: .left)
                        }
                        .column(width: .six)

                        Div {
                            Text {
                                "Bra"
                            }
                            .text(alignment: .right)
                        }
                        .column(width: .six)
                    }
                    .noGutters()

                    Row {
                        Div {
                            Button {
                                "1"
                            }
                            .on(click: "nextTask(0)")
                            .button(style: .light)
                        }
                        .column(width: .two)
                        .offset(width: .one, for: .all)
                        Div {
                            Button {
                                "2"
                            }
                            .on(click: "nextTask(1)")
                            .button(style: .light)
                        }
                        .column(width: .two)
                        Div {
                            Button {
                                "3"
                            }
                            .on(click: "nextTask(2)")
                            .button(style: .light)
                        }
                        .column(width: .two)
                        Div {
                            Button {
                                "4"
                            }
                            .on(click: "nextTask(3)")
                            .button(style: .light)
                        }
                        .column(width: .two)
                        Div {
                            Button {
                                "5"
                            }
                            .on(click: "nextTask(4)")
                            .button(style: .light)
                        }
                        .column(width: .two)
                    }
                    .noGutters()
                }
                .display(.none)
                .id("knowledge-card")
            }
            .scripts {
                Script().source("/assets/js/flash-card/submit-performance.js")
                IF(context.hasBeenCompleted) {
                    Script {
                        "window.onload = presentControlls;"
                    }
                }
            }
        }

        struct LevelColumn: HTMLComponent {

            let icon: HTML
            let description: HTML
            let textAlignment: Text.Alignment

            var body: HTML {
                Text {
                    icon
                    Break()
                    description
                }
                .column(width: .four)
                .text(alignment: textAlignment)
                .style(.heading5)
            }
        }
    }
}
