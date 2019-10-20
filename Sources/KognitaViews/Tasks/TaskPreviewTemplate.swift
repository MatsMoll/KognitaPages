//
//  TaskPreviewTemplate.swift
//  App
//
//  Created by Mats Mollestad on 23/03/2019.
//

import BootstrapKit
import KognitaCore

//struct TaskPreviewContent {
//    var subject: Subject
//    var topic: Topic
//    var task: Task
//    var actionDescription: String
//}

struct TaskPreviewTemplateContext {
    let practiceProgress: Int?
    let session: PracticeSession?
    let taskContent: TaskPreviewContent
    let lastResult: TaskResultContent?
    let user: User
    let taskPath: String
//        let numberOfTasks: Int

    var subject: Subject { return taskContent.subject }
    var topic: Topic { return taskContent.topic }
    var task: Task { return taskContent.task }

    public init(
        task: TaskPreviewContent,
        user: User,
        practiceProgress: Int?,
        session: PracticeSession?,
        lastResult: TaskResultContent?,
        taskPath: String
//            numberOfTasks: Int
        )
    {
        self.practiceProgress = practiceProgress
        self.session = session
        self.taskContent = task
        self.lastResult = lastResult
        self.user = user
        self.taskPath = taskPath
//            self.numberOfTasks = numberOfTasks
    }
}

public struct TaskPreviewTemplate<T>: StaticView {

    let context: TemplateValue<T, TaskPreviewTemplateContext>
    let actionCard: View
    var underSolutionCard: View = ""
    var customScripts: View = ""

    public var body: View {
        BaseTemplate(
            context: RootValue<BaseTemplateContent>.constant(
                .init(
                    title: "Oppgave",
                    description: "Lær ved å øve"
                )
            ),
            content:
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
                        Div {
                            Span { "00:00" }.id("timer")
                        }
                        .float(.right)
                        
                        Text {
                            "localize(.mainTitle)"
                        }
                        .margin(.zero, for: .top)
                        .style(.heading3)

                        IF(context.task.examPaperSemester.isDefined) {
                            Badge {
                                "localize(.exam)" + ": " + context.task.value(at: \.examPaperSemester?.rawValue) + " " + context.task.examPaperYear
                            }
                            .margin(.three, for: .bottom)
                            .background(color: .primary)
                        }

                        IF(context.lastResult.isDefined) {
                            Badge {
                                "Siste resultat: " + context.value(at: \.lastResult?.result.resultScore)
                            }
                            .margin(.three, for: .bottom)
                            .float(.right)
                            .class(context.value(at: \.lastResult?.revisitColorClass))
                        }
                    }
                    .column(width: .twelve)
                }

                QuestionCard(context: context.taskContent)
                actionCard
                DismissableError()
                IF(context.task.solution.isDefined) {
                    SolutionCard(context: context)
                }
                underSolutionCard

                Script().source("https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0/katex.min.js")
                customScripts
            },

            customHeader:
            Link().href("https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0/katex.min.css").relationship("stylesheet")
        )
    }

    struct QuestionCard<T>: StaticView {

        let context: TemplateValue<T, TaskPreviewContent>

        var body: View {
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

        var body: View {
            IF(context.practiceProgress.isDefined) {
                Card {
                    Text {
                        "localize(.sessionProgressTitle)"
                        Span {
                            Span {
                                context.practiceProgress + "% "
                            }
                            .id("goal-progress-label")

                            Small {
                                Span {
                                    context.value(at: \.session?.numberOfTaskGoal)
                                }
                                .id("goal-value") +
                                    " localize(.sessionProgressGoal)"
                            }
                            .text(color: .muted)
                        }
                        .float(.right)
                    }
                    .style(.paragraph)
                    .font(style: .bold)
                    .margin(.two, for: .bottom)

                    ProgressBar(
                        currentValue: context.practiceProgress.unsafelyUnwrapped,
                        valueRange: 0...100
                    )
                        .bar(size: .medium)
                        .bar(id: "goal-progress-bar")
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

    struct SolutionCard<T>: StaticView {

        let context: TemplateValue<T, TaskPreviewTemplateContext>

        var body: View {
            Card {
                IF(context.user.isCreator) {
                    Anchor {
                        Button {
                            "Rediger"
                        }
                        .type(.button)
                        .button(style: .danger)
                        .float(.right)
                    }
                    .href("/creator/tasks/" + context.taskPath + "/" + context.task.id + "/edit")
//                        .target("_blank")
                }
                Div {
                    Text {
                        "localize(.solutionTitle)"
                    }
                    .class("page-title")
                    .style(.heading4)
                }
                .class("page-title-box")
                .margin(.two, for: .bottom)

                context.task.solution.escaping(.unsafeNone)
            }
            .id("solution")
            .display(.none)

        }
    }
}

//public struct TaskPreviewTemplate: LocalizedTemplate {
//
//    public static var localePath: KeyPath<TaskPreviewTemplate.Context, String>?
//
//    public enum LocalizationKeys: String {
//        case repeatTitle = "subjects.repeat.title"
//        case revisitDays = "result.repeat.days"
//        case mainTitle = "exercise.main.title"
//        case exam = "exercise.exam"
//
//        case sessionProgressTitle = "exercise.progress.title"
//        case sessionProgressGoal = "exercise.progress.goal"
//
//        case solutionTitle = "exercise.solution.title"
//        case proposedSolutionTitle = "exercise.solution.proposed.title"
//
//        case errorMessage = "error.message"
//    }
//
//    public struct Context {
//        let base: BaseTemplate.Context
//        let practiceProgress: Int?
//        let session: PracticeSession?
//        let taskContent: TaskPreviewContent
//        let lastResult: TaskResultContent?
//        let user: User
//        let taskPath: String
////        let numberOfTasks: Int
//
//        var subject: Subject { return taskContent.subject }
//        var topic: Topic { return taskContent.topic }
//        var task: Task { return taskContent.task }
//
//        public init(
//            task: TaskPreviewContent,
//            user: User,
//            practiceProgress: Int?,
//            session: PracticeSession?,
//            lastResult: TaskResultContent?,
//            taskPath: String
////            numberOfTasks: Int
//            )
//        {
//            self.base = .init(title: "Oppgave", description: "Lær ved å øve")
//            self.practiceProgress = practiceProgress
//            self.session = session
//            self.taskContent = task
//            self.lastResult = lastResult
//            self.user = user
//            self.taskPath = taskPath
////            self.numberOfTasks = numberOfTasks
//        }
//    }
//
//    let actionCard: CompiledTemplate
//    let underSolutionCard: CompiledTemplate
//    let customScripts: CompiledTemplate
//
//    init(actionCard: CompiledTemplate..., customScripts: CompiledTemplate, underSolutionCard: CompiledTemplate = "") {
//        self.actionCard = actionCard
//        self.underSolutionCard = underSolutionCard
//        self.customScripts = customScripts
//    }
//
//    public func build() -> CompiledTemplate {
//
//        return embed(
//            BaseTemplate(
//                body:
//                div.class("container").child(
//                    div.class("row").child(
//                        div.class("col-12").child(
//                            div.class("page-title-box").child(
////                                small.class("float-right mt-4").child(
////                                    "Antall oppgaver i øvingsettet: " + variable(\.numberOfTasks)
////                                ),
//                                h4.class("page-title").child(
//                                    variable(\.topic.name)
//                                )
//                            )
//                        )
//                    ),
//
//                    // The Question detail
//                    div.class("row").child(
//                        div.class("col-12").child(
//
//                            div.class("float-right").child(
//                                span.id("timer").child(
//                                    "00:00"
//                                )
//                            ),
//
//                            h3.class("mt-0").child(
//                                localize(.mainTitle)
//                            ),
//
//                            renderIf(
//                                isNotNil: \.task.examPaperSemester,
//
//                                div.class("badge badge-primary mb-3").child(
//                                    localize(.exam) + ": " + variable(\.task.examPaperSemester?.rawValue) + " " + variable(\.task.examPaperYear)
//                                )
//                            ),
//
//                            renderIf(
//                                isNotNil: \.lastResult,
//
//                                div.class("mb-3 float-right badge " + variable(\.lastResult?.revisitColorClass)).child(
//                                    "Siste resultat: " + variable(\.lastResult?.result.resultScore)
//                                )
//                            )
//                        )
//                    ),
//
//                    embed(
//                        TaskQuestionCardTemplate(),
//                        withPath: \.taskContent
//                    ),
//
//                    // The answer card
//                    actionCard,
//
//                    DismissableError(),
//
//                    // Hint
//                    //                div.class("card").id("hint-card").style("display: none;").child(
//                    //                    div.class("card-body").child(
//                    //                        h4.class("mt-0 mb-3").child(
//                    //                            "Hints"
//                    //                        ),
//                    //                        ol.id("hint-body")
//                    //                    )
//                    //                ),
//
//                    // Progress bar
//                    renderIf(
//                        isNotNil: \.practiceProgress,
//
//                        div.class("card").child(
//                            div.class("card-body").child(
//                                p.class("mb-2 font-weight-bold").child(
//                                    localize(.sessionProgressTitle),
//                                    span.class("float-right").child(
//                                        span.id("goal-progress-label").child(
//                                            variable(\.practiceProgress) + "% "
//                                        ),
//                                        small.class("text-muted").child(
//                                            span.id("goal-value").child(variable(\.session?.numberOfTaskGoal)) + " " + localize(.sessionProgressGoal)
//                                        )
//                                    )
//                                ),
//                                div.class("progress progress-md").child(
//                                    div.id("goal-progress-bar")
//                                        .class("progress-bar")
//                                        .role("progressbar")
//                                        .ariaValuenow(variable(\.practiceProgress))
//                                        .ariaValuemin(0)
//                                        .ariaValuemax(100)
//                                        .style("width: ", variable(\.practiceProgress), "%;")
//                                        .if(\.practiceProgress >= 100, add: .class("bg-success"))
//                                )
//                            )
//                        )
//                    ),
//
//                    // Solution
//                    renderIf(
//                        isNotNil: \.task.solution,
//
//                        div.id("solution").class("d-none").child(
//
//                            renderIf(
//                                \.user.isCreator,
//
//                                a.href("/creator/tasks/" + variable(\.taskPath) + "/" + variable(\.task.id) + "/edit").target("_blank").child(
//                                    button.type("button").class("btn btn-danger float-right").child(
//                                        "Rediger"
//                                    )
//                                )
//                            ),
//
//                            div.class("page-title-box").child(
//                                h4.class("page-title").child(
//                                    localize(.solutionTitle)
//                                )
//                            ),
//                            div.id("accordion").class("custom-accordion mb-4").child(
//                                div.class("card mb-0").child(
//                                    div.class("card-header").id("headingOne").child(
//                                        h5.class("m-0").child(
//                                            a.class("text-secondary d-block pt-2 pb-2").dataToggle("collapse").href("#collapseOne").ariaExpanded(true).ariaControls("collapseOne").child(
//                                                localize(.proposedSolutionTitle)
//                                            )
//                                        )
//                                    ),
//                                    div.id("collapseOne").class("collapse show").ariaLabelledby("headingOne").dataParent("#accordion").child(
//                                        div.class("card-body").child(
//
//                                            variable(\.task.solution, escaping: .unsafeNone)
//                                        )
//                                    )
//                                )
//                            )
//                        )
//                    ),
//
//                    underSolutionCard,
//
//                    script.src("https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0/katex.min.js"),
//                    script.src("/assets/js/app.min.js").type("text/javascript"),
//                    customScripts
//                ),
//
//                customHeader:
//                link.href("https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0/katex.min.css").rel("stylesheet")
//            ),
//            withPath: \.base)
//    }
//
//
//    // Subviews
//    struct TaskQuestionCardTemplate: ContextualTemplate {
//
//        typealias Context = TaskPreviewContent
//
//        func build() -> CompiledTemplate {
//            return
//                div.class("row").child(
//                    div.class("col-12").child(
//
//                        div.class("card d-block").child(
//                            div.class("card-body").child(
//
//                                small.class("text-secondary").child(
//                                    variable(\.actionDescription)
//                                ),
//
//                                renderIf(
//                                    \.task.description != nil,
//                                    p.class("text-secondary mb-2 mt-3").child(
//                                        variable(\.task.description, escaping: .unsafeNone)
//                                    )
//                                ),
//
//                                h5.addDynamic(.class("mt-3"), with: \.task.description == nil).child(
//                                    variable(\.task.question)
//                                )
//                            )
//                        )
//                    )
//            )
//        }
//    }
//}

