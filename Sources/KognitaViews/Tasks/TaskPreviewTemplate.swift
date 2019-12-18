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
    let session: PracticeSession?
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
        session: PracticeSession?,
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

public struct TaskPreviewTemplate<T>: HTMLComponent {

    let context: TemplateValue<T, TaskPreviewTemplateContext>
    let actionCard: HTML
    var underSolutionCard: HTML = ""
    var customScripts: HTML = ""

    init(context: TemplateValue<T, TaskPreviewTemplateContext>, @HTMLBuilder actionCard: () -> HTML) {
        self.context = context
        self.actionCard = actionCard()
        self.underSolutionCard = ""
        self.customScripts = ""
    }

    init(context: TemplateValue<T, TaskPreviewTemplateContext>, actionCard: HTML, underSolutionCard: HTML, customScripts: HTML) {
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

                ProgressCard(context: context)

                Row {
                    Div {
//                        Div {
//                            Span { "00:00" }.id("timer")
//                        }
//                        .float(.right)

                        Text(Strings.exerciseMainTitle)
                            .margin(.zero, for: .top)
                            .style(.heading3)

                        IF(isDefined: context.task.examPaperSemester) { exam in
                            Badge {
                                Localized(key: Strings.exerciseExam)
                                ": " + exam.rawValue + " " + context.task.examPaperYear
                            }
                            .margin(.three, for: .bottom)
                            .background(color: .primary)
                        }

//                        IF(isDefined: context.lastResult) { result in
//                            Badge {
//                                "Siste resultat: "
//                                result.result.resultScore
//                            }
//                            .margin(.three, for: .bottom)
//                            .float(.right)
//                            .class(result.revisitColorClass)
//                        }
                    }
                    .column(width: .twelve)
                }

                QuestionCard(context: context.taskContent)
                actionCard
                DismissableError()
                Div()
                    .id("solution")
                    .display(.none)
//                IF(context.task.solution.isDefined) {
//                    SolutionCard(context: context)
//                }
                underSolutionCard

                Script().source("https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0/katex.min.js")
                customScripts
            }
        }
        .header {
            Link().href("https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0/katex.min.css").relationship(.stylesheet)
        }
    }

    struct QuestionCard<T>: HTMLComponent {

        let context: TemplateValue<T, TaskPreviewContent>

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

    struct ProgressCard<T>: StaticView {

        let context: TemplateValue<T, TaskPreviewTemplateContext>

        var body: HTML {
            IF(isDefined: context.practiceProgress) { progress in
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
                                    IF(isDefined: context.session) {
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

    public let context: RootValue<[TaskSolution.Response]> = .root()

    public var body: HTML {
        Accordions(values: context, title: { (solution, index) in
            Text {
                Localized(key: Strings.exerciseProposedSolutionTitle)
                Span {
                    Italic().class("mdi mdi-chevron-down accordion-arrow")
                }
                .float(.right)
            }
            .style(.heading4)

            IF(solution.creatorName.isDefined) {
                "Lagd av: " + solution.creatorName
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
            solution.solution
                .escaping(.unsafeNone)
        }
//        ForEach(in: context) { solution in
//            SolutionCard(context: solution)
//        }
    }

    struct SolutionCard<T>: HTMLComponent {

            let context: TemplateValue<T, TaskSolution.Response>

            var body: HTML {
                Card {
                    Div {
                        Div {
                            Text(Strings.exerciseProposedSolutionTitle)
                                .style(.heading4)
                        }
                        .class("page-title")
                        Div {
                            IF(context.creatorName.isDefined) {
                                "Lagd av: " + context.creatorName
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

struct Accordions<A, B>: HTMLComponent {

    let values: TemplateValue<A, [B]>
    let title: ((RootValue<B>, RootValue<Int>)) -> HTML
    let content: ((RootValue<B>, RootValue<Int>)) -> HTML
    var id: String = "accordion"

    public init(values: TemplateValue<A, [B]>, @HTMLBuilder title: @escaping ((RootValue<B>, RootValue<Int>)) -> HTML, @HTMLBuilder content: @escaping ((RootValue<B>, RootValue<Int>)) -> HTML) {
        self.values = values
        self.title = title
        self.content = content
    }

    var body: HTML {
        Div {
            ForEach(enumerated: values) { value in
                card(value: value)
            }
        }
        .class("custom-accordion mb-4")
        .id(id)
    }

    func card(value: (RootValue<B>, index: RootValue<Int>)) -> HTML {
        Div {
            heading(value: value)
            content(value: value)
        }
        .class("card")
    }
    
    func heading(value: (RootValue<B>, index: RootValue<Int>)) -> HTML {
        return Div {
            Anchor {
                title(value)
            }
                .text(color: .secondary)
                .display(.block)
                .padding(.two, for: .vertical)
                .data(for: "toggle", value: "collapse")
                .data(for: "target", value: "#" + bodyId(value.index))
                .aria(for: "controls", value: bodyId(value.index))
        }
        .class("card-header")
        .id(headingId(value.index))
    }

    func content(value: (RootValue<B>, index: RootValue<Int>)) -> HTML {
        return Div {
            Div {
                content(value)
            }
            .class("card-body")
        }
        .class("collapse" + IF(value.index == 0) { " show" })
        .aria(for: "labelledby", value: headingId(value.index))
        .data(for: "parent", value: "#\(id)")
        .id(bodyId(value.index))
    }

    func bodyId(_ index: RootValue<Int>) -> HTML {
        "\(id)-body" + index
    }

    func headingId(_ index: RootValue<Int>) -> HTML {
        "\(id)-heading" + index
    }
}
