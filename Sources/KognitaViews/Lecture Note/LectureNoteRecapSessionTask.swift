//
//  LectureNoteRecapSessionTask.swift
//  KognitaViews
//
//  Created by Mats Mollestad on 05/10/2020.
//

import Foundation

extension LectureNote.RecapSession {
    public enum Templates {}
}

extension LectureNote.RecapSession.Templates {

    public struct ExecuteTask: HTMLTemplate {

        public struct Context {
            public init(executeTask: LectureNote.RecapSession.ExecuteTask) {
                self.executeTask = executeTask
            }

            let executeTask: LectureNote.RecapSession.ExecuteTask
            var task: GenericTask { executeTask.task }
            var hasBeenCompleted: Bool { executeTask.submitedAnswer != nil }
        }

        public init() {}

        public var body: HTML {
            BaseTemplate(
                context: .init(
                    title: "Repiter forelesning",
                    description: "Repiter forelesning",
                    showCookieMessage: false
                )
            ) {
                Container {
                    PageTitle(title: "Repiter")
                    RecapSessionProgressBar(context: context.executeTask)
                    Row {
                        Div {
                            TaskPreviewTemplate.QuestionCard(
                                exam: .constant(nil),
                                description: .constant(nil),
                                question: context.task.question
                            )

                            TypingInputCard(prevAnswer: context.executeTask.submitedAnswer)
                        }
                        .column(width: .seven, for: .large)

                        Div {
                            EstimatingCard()
                            TaskSolutionCard(
                                fetchUrl: Script.fetchSolutionSessionUrl,
                                extraScripts: Script.recapSessionIDFromUri + Script.recapSessionTaskIndexFromUri
                            )
                            KnowlegedCard(score: .constant(nil))
                            DismissableError()
                        }
                        .column(width: .five, for: .large)
                    }
                    .id("main-task-content")

                    Row {
                        Div { NavigationCard(context: context.executeTask) }
                            .column(width: .twelve)
                    }
                    .class("fixed-bottom")
                    .id("nav-card")
                }
            }
            .header {
                Link().href("/assets/css/vendor/simplemde.min.css").relationship(.stylesheet).type("text/css")
                Link().href("/assets/css/vendor/katex.min.css").relationship(.stylesheet)
            }
            .scripts {
                Script(source: "/assets/js/vendor/simplemde.min.js")
                Script(source: "/assets/js/vendor/marked.min.js")
                Script(source: "/assets/js/vendor/katex.min.js")
                Script(source: "/assets/js/markdown-renderer.js")
                Script(source: "/assets/js/lecture-note-recap-session/submit.js")
                Script {
    """
    $("#main-task-content").css("padding-bottom", $("#nav-card").height() + 20);
    """
                }
                Script { Script.autoResizeTextAreas }
                IF(context.hasBeenCompleted) {
                    context.executeTask.hasCompletedScript.asScript
                }
            }
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

struct KnowlegedCard: HTMLComponent {

    let score: TemplateValue<Double?>

    var body: HTML {
        Card {
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

            Row { ScoreButtons(score: score) }
                .noGutters()
                .text(alignment: .center)
        }
        .display(.none)
        .id("knowledge-card")
    }
}

private struct EstimatingCard: HTMLComponent {
    var body: HTML {
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
}

private struct NavigationCard: HTMLComponent {

    let context: TemplateValue<LectureNote.RecapSession.ExecuteTask>

    var body: HTML {
        Card {
            Container {
                Form {
                    Anchor {
                        Strings.exerciseNextButton
                            .localized()
                        MaterialDesignIcon(.arrowRight)
                            .margin(.one, for: .left)

                    }
                    .id("nextButton")
                    .href(context.nextTaskIndex)
                    .display(.none)
                    .float(.right)
                    .button(style: .primary)

                    Unwrap(context.prevTaskIndex) { prevTaskIndex in
                        Anchor {
                            MaterialDesignIcon(.arrowLeft)
                                .margin(.one, for: .right)
                            "Forrige"
                        }
                        .button(style: .light)
                        .href(prevTaskIndex)
                        .float(.left)
                    }

                    Div {
                        Anchor(Strings.exerciseStopSessionButton)
                            .button(style: .danger)
                            .href("../results")
//                            .on(click: "endSession()")
                    }
                    .text(alignment: .center)
                }
//                .action("/practice-sessions/" + context.sessionID + "/end")
//                .method(.post)
                .id("end-session-form")
            }
            .padding(.zero, for: .horizontal)
        }
        .margin(.zero, for: .bottom)
    }

//    var scripts: HTML {
//        NodeList {
//            Script {
//"""
//function endSession() { $("#end-session-form").submit() }
//"""
//            }
//            body.scripts
//        }
//    }
}

private struct TypingInputCard: HTMLComponent {

    let prevAnswer: TemplateValue<TypingTask.Answer?>

    var body: HTML {
        Card {
            Label {
                "Skriv svaret her"
            }
            InputGroup {
                TextArea {
                    Unwrap(prevAnswer) { (answer: TemplateValue<TypingTask.Answer>) in
                        answer.answer
                    }
                }
                .id("flash-card-answer")
                .placeholder("Skriv et passende svar eller trykk på *sjekk svar* for å se løsningen")
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
}

private struct RecapSessionProgressBar: HTMLComponent {

    let context: TemplateValue<LectureNote.RecapSession.ExecuteTask>

    var body: HTML {
        Row {
            Div {
                Card {
                    Text {
                        Localized(key: Strings.exerciseSessionProgressTitle)
                        Span {
                            Span {
                                context.progress.timesHundred
                                "% "
                            }
                            .id("goal-progress-label")

                            Small {
                                Span { context.numberOfTasksGoal }
                                    .id("goal-value")
                                " "
                                Localized(key: Strings.exerciseSessionProgressGoal)
                            }
                            .text(color: .muted)
                        }
                        .float(.right)
                    }
                    .style(.paragraph)
                    .font(style: .bold)
                    .margin(.two, for: .bottom)

                    ProgressBar(
                        currentValue: context.progress.timesHundred,
                        valueRange: 0...100
                    )
                        .bar(size: .medium)
                        .bar(id: "goal-progress-bar")
//                        .modify(if: context.practiceProgress >= 100) {
//                            $0.bar(style: .success)
//                    }
                    .margin(.two, for: .bottom)
                }
            }
            .column(width: .twelve)
        }
    }
}

extension LectureNote.RecapSession.ExecuteTask {

    fileprivate var setKnowledgeScoreScript: String {
        if let score = registeredScore {
            return "knowledgeScore=\(score * 4)"
        } else {
            return ""
        }
    }

    fileprivate var hasCompletedScript: String {
        "\(setKnowledgeScoreScript);window.onload = presentControlls;"
    }
}
