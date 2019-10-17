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
    public struct Execute: TemplateView {

        public struct Context {
            let locale = "nb"
            let taskPreview: TaskPreviewTemplateContext
            var nextTaskIndex: Int?
            var prevTaskIndex: Int?

            var session: PracticeSession? { return taskPreview.session }
            var task: Task { return taskPreview.task }
            var topic: Topic { return taskPreview.topic }
            var hasBeenCompleted: Bool { return taskPreview.lastResult?.sessionId == session?.id }
            var score: Double? {
                if let score = taskPreview.lastResult?.result.resultScore {
                    return score * 4
                } else {
                    return nil
                }
            }

            public init(
                taskPreview: TaskPreviewContent,
                user: User,
                currentTaskIndex: Int? = nil,
                practiceProgress: Int? = nil,
                session: PracticeSession? = nil,
                lastResult: TaskResultContent? = nil,
                numberOfTasks: Int
            ) {
                self.taskPreview = .init(
                    task: taskPreview,
                    user: user,
                    practiceProgress: practiceProgress,
                    session: session,
                    lastResult: lastResult,
                    taskPath: "flash-card"
    //                numberOfTasks: numberOfTasks
                )
                if let currentTaskIndex = currentTaskIndex {
                    if currentTaskIndex > 1 {
                        self.prevTaskIndex = currentTaskIndex - 1
                    }
                    self.nextTaskIndex = currentTaskIndex + 1
                }
            }
        }

        public init() {}

        public let context: RootValue<Context> = .root()

        public var body: View {
            TaskPreviewTemplate(
                context: context.taskPreview,
                actionCard:
                Card {
                    Button {
                        Italic().class("mdi mdi-send")
                            .margin(.one, for: .right)
                        "localize(.answerButton)"
                    }
                    .type(.button)
                    .id("submitButton")
                    .button(style: .success)
                    .margin(.one, for: .right)
                    .on(click: "revealSolution();")

                    IF(context.session.isDefined) {
                        Button {
                            "localize(.stopSessionButton)"
                        }
                        .float(.right)
                        .button(style: .danger)
                        .margin(.one, for: .left)
                        .on(click: "submitAndEndSession();")
                    }
                },

                underSolutionCard:
                Card {
                    IF(context.nextTaskIndex.isDefined) {
                        Input()
                            .id("next-task")
                            .type(.hidden)
                            .value(context.nextTaskIndex)

                        Button {
                            "localize(.nextButton)"
                            Italic().class("mdi mdi-arrow-right")
                                .margin(.one, for: .left)
                        }
                        .float(.right)
                        .button(style: .primary)
                        .on(click: "nextTask();")
                    }
                    IF(context.prevTaskIndex.isDefined) {
                        Anchor {
                            Button {
                                Italic()
                                    .class("mdi mdi-arrow-left")
                                    .margin(.one, for: .right)
                                "Forrige"
                            }
                            .button(style: .light)
                            .margin(.two, for: .right)
                            .float(.right)
                        }
                        .href(context.prevTaskIndex)
                    }
                    Text {
                        "Hvordan gikk det?"
                    }
                    .margin(.one, for: .top)
                    .margin(.three, for: .bottom)
                    .style(.heading4)

                    Row {
                        LevelColumn(
                            icon: "😒",
                            description: "Har ingen kontroll",
                            textAlignment: .left
                        )
                        LevelColumn(
                            icon: "😅",
                            description: "Har litt kontroll",
                            textAlignment: .center
                        )
                        LevelColumn(
                            icon: "🧐",
                            description: "Har full kontroll",
                            textAlignment: .right
                        )
                    }
                    .noGutters()

                    Input()
                        .class("custom-range")
                        .id("knowledge-slider")
                        .type(.range)
                        .name("range")
                        .min(value: 0)
                        .max(value: 4)
                        .value(
                            IF(context.score.isDefined) {
                                context.score
                            }.else {
                                2
                            }
                    )
//                            .addDynamic(.disable, with: \.score != nil)
                }
                .display(.none)
                .id("knowledge-card"),

                customScripts:
                Script().source("/assets/js/flash-card/submit-performance.js") +
                Script().source("/assets/js/practice-session-end.js") +
                IF(context.hasBeenCompleted) {
                    Script {
                        "window.onload = presentControlls;"
                    }
                }
            )
        }

        struct LevelColumn: StaticView {

            let icon: View
            let description: View
            let textAlignment: Text.Alignment

            var body: View {
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
