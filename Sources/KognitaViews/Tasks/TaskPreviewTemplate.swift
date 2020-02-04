//
//  TaskPreviewTemplate.swift
//  App
//
//  Created by Mats Mollestad on 23/03/2019.
//

import BootstrapKit
import KognitaCore

struct TaskPreviewTemplateContext {
    let practiceProgress: Int?
    let session: PracticeSessionRepresentable?
    let taskContent: TaskPreviewContent
    let lastResult: TaskResultContent?
    let user: UserContent
    let taskPath: String

    var subject: Subject { return taskContent.subject }
    var topic: Topic { return taskContent.topic }
    var task: Task { return taskContent.task }

    public init(
        task: TaskPreviewContent,
        user: UserContent,
        practiceProgress: Int?,
        session: PracticeSessionRepresentable?,
        lastResult: TaskResultContent?,
        taskPath: String
    ) {
        self.practiceProgress = practiceProgress
        self.session = session
        self.taskContent = task
        self.lastResult = lastResult
        self.user = user
        self.taskPath = taskPath
    }
}

public struct TaskPreviewTemplate: HTMLComponent {

    let context: TemplateValue<TaskPreviewTemplateContext>
    let actionCard: HTML
    var underSolutionCard: HTML = ""
    var customScripts: HTML = ""

    init(context: TemplateValue<TaskPreviewTemplateContext>, @HTMLBuilder actionCard: () -> HTML) {
        self.context = context
        self.actionCard = actionCard()
        self.underSolutionCard = ""
        self.customScripts = ""
    }

    init(context: TemplateValue<TaskPreviewTemplateContext>, actionCard: HTML, underSolutionCard: HTML, customScripts: HTML) {
        self.context = context
        self.actionCard = actionCard
        self.underSolutionCard = underSolutionCard
        self.customScripts = customScripts
    }

    func underSolutionCard(@HTMLBuilder _ card: () -> HTML) -> TaskPreviewTemplate {
        TaskPreviewTemplate(context: context, actionCard: actionCard, underSolutionCard: card(), customScripts: customScripts)
    }

    func scripts(@HTMLBuilder _ scripts: () -> HTML) -> TaskPreviewTemplate {
        TaskPreviewTemplate(context: context, actionCard: actionCard, underSolutionCard: underSolutionCard, customScripts: scripts())
    }

    public var body: HTML {
        BaseTemplate(context: .init(
            title: "Oppgave",
            description: "Lær ved å øve"
        )) {
            Container {
                Row {
                    Div {
                        Div {
                            H4 {
                                context.topic.name
                            }
                            .class("page-title")
                        }
                        .class("page-title-box")
                    }
                    .column(width: .twelve)
                }

                Row {
                    Div {

                        Text(Strings.exerciseMainTitle)
                            .margin(.zero, for: .top)
                            .style(.heading3)

                        Unwrap(context.task.examPaperSemester) { exam in
                            Badge {
                                Strings.exerciseExam.localized()
                                ": " + exam.rawValue + " " + context.task.examPaperYear
                            }
                            .margin(.three, for: .bottom)
                            .background(color: .primary)
                        }
                    }
                    .column(width: .twelve)
                }

                ContentStructure {
                    QuestionCard(context: context.taskContent)
                    actionCard
                    Div()
                    .id("solution")
                    .display(.none)
                }
                .secondary {
                    ProgressCard(context: context)
                    DismissableError()
                    underSolutionCard
                }

//                QuestionCard(context: context.taskContent)
//                actionCard
//                DismissableError()
//                Div()
//                    .id("solution")
//                    .display(.none)
////                IF(context.task.solution.isDefined) {
////                    SolutionCard(context: context)
////                }
//                underSolutionCard
            }
        }
        .header {
            Link().href("https://cdn.jsdelivr.net/npm/katex@0.11.1/dist/katex.min.css").relationship(.stylesheet)
        }
        .scripts {
            Script(source: "https://cdn.jsdelivr.net/npm/marked/marked.min.js")
            Script().source("https://cdn.jsdelivr.net/npm/katex@0.11.1/dist/katex.min.js")
            Script(source: "/assets/js/markdown-renderer.js")
            customScripts
        }
    }

    struct QuestionCard: HTMLComponent {

        let context: TemplateValue<TaskPreviewContent>

        var body: HTML {
            Row {
                Div {
                    Card {
                        Small {
                            context.actionDescription
                        }
                        .text(color: .secondary)

                        IF(context.task.description.isDefined) {
                            Text {
                                context.task.description
                                    .escaping(.unsafeNone)
                            }
                            .style(.paragraph)
                            .text(color: .secondary)
                            .margin(.two, for: .bottom)
                            .margin(.three, for: .top)
                            .id("task-description")
                        }
                        Text {
                            context.task.question
                        }
                        .style(.heading5)
                        .modify(if: context.task.description.isNotDefined) {
                            $0.margin(.three, for: .top)
                        }
                    }
                    .display(.block)
                }
                .column(width: .twelve)
            }
        }
    }

    struct ProgressCard: HTMLComponent {

        let context: TemplateValue<TaskPreviewTemplateContext>

        var body: HTML {
            Unwrap(context.practiceProgress) { progress in
                Card {
                    Text {
                        Localized(key: Strings.exerciseSessionProgressTitle)
                        Span {
                            Span {
                                context.practiceProgress + "% "
                            }
                            .id("goal-progress-label")

                            Small {
                                Span {
                                    Unwrap(context.session) {
                                        $0.numberOfTaskGoal
                                    }
                                }
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
                        currentValue: progress,
                        valueRange: 0...100
                    )
                        .bar(size: .medium)
                        .bar(id: "goal-progress-bar")
                        .modify(if: progress >= 100) {
                            $0.bar(style: .success)
                    }
//                        Div {
//                            ProgressBar(
//                                currentValue: context.practiceProgress.unsafelyUnwrapped,
//                                valueRange: 0...100
//                            )
//                            Div()
//                                .id("goal-progress-bar")
//                                .class("progress-bar")
//                                .role("progressbar")
//                                .aria(for: "valuenow", value: variable(\.practiceProgress))
//                                .aria(for: "valuemin", value: 0)
//                                .aria(for: "valuemax", value: 100)
//                                .style("width: ", variable(\.practiceProgress), "%;")
//                                .if(\.practiceProgress >= 100, add: .class("bg-success"))
//                        }
//                        .class("progress progress-md")
                }
            }

        }
    }
}

typealias StaticView = HTMLComponent
typealias TemplateView = HTMLTemplate

public struct TaskSolutionsTemplate: HTMLTemplate {

    public init() {}

    public let context: TemplateValue<[TaskSolution.Response]> = .root()

    public var body: HTML {
        Accordions(values: context, title: { (solution, index) in
            Text {
                Localized(key: Strings.exerciseProposedSolutionTitle)
                Span {
                    MaterialDesignIcon(.chevronDown)
                        .class("accordion-arrow")
                }
                .float(.right)
            }
            .style(.heading4)

            IF(solution.creatorUsername.isDefined) {
                "Laget av: " + solution.creatorUsername
            }
            IF(solution.approvedBy.isDefined) {
                Badge {
                    "Verifisert av: " + solution.approvedBy
                }
                .background(color: .success)
                .margin(.two, for: .left)
            }.else {
                Badge {
                    "Ikke verifisert enda"
                }
                .background(color: .warning)
                .margin(.two, for: .left)
            }
        }) { (solution, index) in
            Div {
                solution.solution
                    .escaping(.unsafeNone)
            }
            .class("solutions")
        }
    }

    struct SolutionCard: HTMLComponent {

        let context: TemplateValue<TaskSolution.Response>

        var body: HTML {
            Card {
                Div {
                    Div {
                        Text(Strings.exerciseProposedSolutionTitle)
                            .style(.heading4)
                    }
                    .class("page-title")
                    Div {
                        IF(context.creatorUsername.isDefined) {
                            "Laget av: " + context.creatorUsername
                        }
                        IF(context.approvedBy.isDefined) {
                            Badge {
                                "Verifisert av: " + context.approvedBy
                            }
                            .background(color: .success)
                            .margin(.two, for: .left)
                        }.else {
                            Badge {
                                "Ikke verifisert enda"
                            }
                            .background(color: .warning)
                            .margin(.two, for: .left)
                        }
                    }
                }
                .class("page-title-box")
                .margin(.two, for: .bottom)

                context.solution.escaping(.unsafeNone)
            }
        }
    }
}
