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
                prevAnswer: FlashCardAnswer?
            ) {
                self.taskPreview = .init(
                    task: taskPreview,
                    user: user,
                    practiceProgress: practiceProgress,
                    session: session,
                    taskPath: "flash-card",
                    currentTaskIndex: currentTaskIndex,
                    lastResult: lastResult
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
                            Unwrap(context.prevAnswer) { (answer: TemplateValue<FlashCardAnswer>) in
                                answer.answer
                            }
                        }
                        .id("flash-card-answer")
                        .placeholder("Skriv et passende svar, eller trykk på *sjekk svar* for å se løsningen")
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
                        ScoreButtons(score: context.score)
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

        private struct ScoreButton: HTMLComponent {

            let score: Int

            var body: HTML {
                Button { score + 1 }
                    .on(click: "registerScore(\(score))")
                    .id(score)
                    .button(style: .light)
            }
        }

        private struct ScoreButtons: HTMLComponent {

            let score: TemplateValue<Double?>

            var body: HTML {
                NodeList {
                    Div { ScoreButton(score: 0) }
                        .column(width: .two)
                        .offset(width: .one, for: .all)

                    Div { ScoreButton(score: 1) }
                        .column(width: .two)

                    Div { ScoreButton(score: 2) }
                        .column(width: .two)

                    Div { ScoreButton(score: 3) }
                        .column(width: .two)

                    Div { ScoreButton(score: 4) }
                        .column(width: .two)
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

extension FlashCardTask.Templates.Execute.Context {
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
        Script {
            self
        }
    }
}
