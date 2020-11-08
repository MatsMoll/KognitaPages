//
//  FlashCardTaskTemplate.swift
//  App
//
//  Created by Mats Mollestad on 31/03/2019.
//

import BootstrapKit

extension TypingTask {
    public struct Templates {}
}

extension PracticeSession.Templates {
    public struct ExecuteTypingTask: HTMLTemplate {

        public struct Context {
            let taskPreview: TaskPreviewTemplateContext

            var sessionID: Sessions.ID { taskPreview.sessionID }
            var task: Task { return taskPreview.task }
            var topic: Topic { return taskPreview.topic }
            var hasBeenCompleted: Bool { return taskPreview.lastResult?.sessionID == sessionID }
            var score: Double? {
                if let score = taskPreview.lastResult?.resultScore {
                    return score * 4
                } else {
                    return nil
                }
            }
            var prevAnswer: TypingTask.Answer?

            public init(
                taskPreview: TaskPreviewContent,
                user: User,
                lastResult: TaskResult? = nil,
                prevAnswer: TypingTask.Answer?,
                progressState: Sessions.ProgressState
            ) {
                self.taskPreview = .init(
                    task: taskPreview,
                    progressState: progressState,
                    user: user,
                    taskPath: "typing-task",
                    lastResult: lastResult
                )
                self.prevAnswer = prevAnswer
            }
        }

        public init() {}

        public let context: TemplateValue<Context> = .root()

        public var body: HTML {
            TaskPreviewTemplate(context: context.taskPreview, sessionType: .practice) {
                Card {
                    Label {
                        "Skriv svaret her"
                    }
                    InputGroup {
                        TextArea {
                            Unwrap(context.prevAnswer) { (answer: TemplateValue<TypingTask.Answer>) in
                                answer.answer
                            }
                        }
                        .id("flash-card-answer")
                        .placeholder("Skriv et passende svar eller trykk på *sjekk svar* for å se løsningen")
                    }
                    .margin(.two, for: .bottom)

                    Button {
                        MaterialDesignIcon(.send)
                            .margin(.one, for: .right)

                        Strings.exerciseAnswerButton
                            .localized()
                    }
                    .type(.button)
                    .id("submitButton")
                    .button(style: .success)
                    .margin(.one, for: .right)
                    .on(click: "revealSolution();")

                    Button {
                        MaterialDesignIcon(.commentQuestion)
                            .margin(.one, for: .right)
                        "Få et hint"
                    }
                    .on(click: "loadHints()")
                    .button(style: .info)
                }
            }
            .overSolutionCard {
                Card {
                    Text { "Vi estimerer ..." }
                        .style(.heading5)

                    Span().id("estimate-spinner")

                    Text { "" }
                        .id("answer-estimate")
                        .display(.none)
                        .style(.heading4)
                }
                .id("estimated-score-card")
                .display(.none)

            }
            .underSolutionCard {

                Card {
                    Input()
                        .id("next-task")
                        .type(.hidden)
                        .value(context.taskPreview.nextTaskIndex)

                    Text { "Hvor bra samsvarte du med løsningsforslaget?" }
                        .margin(.one, for: .top)
                        .margin(.three, for: .bottom)
                        .style(.heading4)

                    Row {
                        Div {
                            Text { "Dårlig" }
                                .text(alignment: .left)
                        }
                        .column(width: .four)

                        Div {
                           Text { "Middels" }
                               .text(alignment: .center)
                       }
                       .column(width: .four)

                        Div {
                            Text { "Bra" }
                                .text(alignment: .right)
                        }
                        .column(width: .four)
                    }
                    .noGutters()

                    Row {
                        TypingTask.Templates.ScoreButtons(score: context.score)
                    }
                    .noGutters()
                    .text(alignment: .center)
                }
                .display(.none)
                .id("knowledge-card")
            }
            .scripts {
                Script().source("/assets/js/flash-card/submit-performance.js")
                IF(context.hasBeenCompleted) {
                    context.hasCompletedScript.asScript
                }
            }
        }
    }
}

extension PracticeSession.Templates.ExecuteTypingTask.Context {
    fileprivate var knowledgeScoreScript: String {
        if let score = score {
            return "knowledgeScore=\(score)"
        } else {
            return ""
        }
    }

    fileprivate var hasCompletedScript: String {
        "\(knowledgeScoreScript);window.onload = presentControlls;"
    }
}

extension TemplateValue where Value == String {
    var asScript: Script {
        Script { self }
    }
}
