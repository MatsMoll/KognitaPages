//
//  TaskPreviewTemplate.swift
//  App
//
//  Created by Mats Mollestad on 23/03/2019.
//

import HTMLKit
import KognitaCore

//struct TaskPreviewContent {
//    var subject: Subject
//    var topic: Topic
//    var task: Task
//    var actionDescription: String
//}

public struct TaskPreviewTemplate: LocalizedTemplate {

    public static var localePath: KeyPath<TaskPreviewTemplate.Context, String>?

    public enum LocalizationKeys: String {
        case repeatTitle = "subjects.repeat.title"
        case revisitDays = "result.repeat.days"
        case mainTitle = "exercise.main.title"
        case exam = "exercise.exam"

        case sessionProgressTitle = "exercise.progress.title"
        case sessionProgressGoal = "exercise.progress.goal"

        case solutionTitle = "exercise.solution.title"
        case proposedSolutionTitle = "exercise.solution.proposed.title"

        case errorMessage = "error.message"
    }

    public struct Context {
        let base: BaseTemplate.Context
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
            self.base = .init(title: "Oppgave", description: "Lær ved å øve")
            self.practiceProgress = practiceProgress
            self.session = session
            self.taskContent = task
            self.lastResult = lastResult
            self.user = user
            self.taskPath = taskPath
//            self.numberOfTasks = numberOfTasks
        }
    }

    let actionCard: CompiledTemplate
    let underSolutionCard: CompiledTemplate
    let customScripts: CompiledTemplate

    init(actionCard: CompiledTemplate..., customScripts: CompiledTemplate, underSolutionCard: CompiledTemplate = "") {
        self.actionCard = actionCard
        self.underSolutionCard = underSolutionCard
        self.customScripts = customScripts
    }

    public func build() -> CompiledTemplate {

        return embed(
            BaseTemplate(
                body:
                div.class("container").child(
                    div.class("row").child(
                        div.class("col-12").child(
                            div.class("page-title-box").child(
//                                small.class("float-right mt-4").child(
//                                    "Antall oppgaver i øvingsettet: " + variable(\.numberOfTasks)
//                                ),
                                h4.class("page-title").child(
                                    variable(\.topic.name)
                                )
                            )
                        )
                    ),

                    // The Question detail
                    div.class("row").child(
                        div.class("col-12").child(

                            div.class("float-right").child(
                                span.id("timer").child(
                                    "00:00"
                                )
                            ),

                            h3.class("mt-0").child(
                                localize(.mainTitle)
                            ),

                            renderIf(
                                isNotNil: \.task.examPaperSemester,

                                div.class("badge badge-primary mb-3").child(
                                    localize(.exam) + ": " + variable(\.task.examPaperSemester?.rawValue) + " " + variable(\.task.examPaperYear)
                                )
                            ),

                            renderIf(
                                isNotNil: \.lastResult,

                                div.class("mb-3 float-right badge " + variable(\.lastResult?.revisitColorClass)).child(
                                    "Siste resultat: " + variable(\.lastResult?.result.resultScore)
                                )
                            )
                        )
                    ),

                    embed(
                        TaskQuestionCardTemplate(),
                        withPath: \.taskContent
                    ),

                    // The answer card
                    actionCard,

                    DismissableError(),

                    // Hint
                    //                div.class("card").id("hint-card").style("display: none;").child(
                    //                    div.class("card-body").child(
                    //                        h4.class("mt-0 mb-3").child(
                    //                            "Hints"
                    //                        ),
                    //                        ol.id("hint-body")
                    //                    )
                    //                ),

                    // Progress bar
                    renderIf(
                        isNotNil: \.practiceProgress,

                        div.class("card").child(
                            div.class("card-body").child(
                                p.class("mb-2 font-weight-bold").child(
                                    localize(.sessionProgressTitle),
                                    span.class("float-right").child(
                                        span.id("goal-progress-label").child(
                                            variable(\.practiceProgress) + "% "
                                        ),
                                        small.class("text-muted").child(
                                            span.id("goal-value").child(variable(\.session?.numberOfTaskGoal)) + " " + localize(.sessionProgressGoal)
                                        )
                                    )
                                ),
                                div.class("progress progress-md").child(
                                    div.id("goal-progress-bar")
                                        .class("progress-bar")
                                        .role("progressbar")
                                        .ariaValuenow(variable(\.practiceProgress))
                                        .ariaValuemin(0)
                                        .ariaValuemax(100)
                                        .style("width: ", variable(\.practiceProgress), "%;")
                                        .if(\.practiceProgress >= 100, add: .class("bg-success"))
                                )
                            )
                        )
                    ),

                    // Solution
                    renderIf(
                        isNotNil: \.task.solution,

                        div.id("solution").class("d-none").child(

                            renderIf(
                                \.user.isCreator,

                                a.href("/creator/tasks/" + variable(\.taskPath) + "/" + variable(\.task.id) + "/edit").target("_blank").child(
                                    button.type("button").class("btn btn-danger float-right").child(
                                        "Rediger"
                                    )
                                )
                            ),

                            div.class("page-title-box").child(
                                h4.class("page-title").child(
                                    localize(.solutionTitle)
                                )
                            ),
                            div.id("accordion").class("custom-accordion mb-4").child(
                                div.class("card mb-0").child(
                                    div.class("card-header").id("headingOne").child(
                                        h5.class("m-0").child(
                                            a.class("text-secondary d-block pt-2 pb-2").dataToggle("collapse").href("#collapseOne").ariaExpanded(true).ariaControls("collapseOne").child(
                                                localize(.proposedSolutionTitle)
                                            )
                                        )
                                    ),
                                    div.id("collapseOne").class("collapse show").ariaLabelledby("headingOne").dataParent("#accordion").child(
                                        div.class("card-body").child(

                                            variable(\.task.solution, escaping: .unsafeNone)
                                        )
                                    )
                                )
                            )
                        )
                    ),

                    underSolutionCard,

                    script.src("https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0/katex.min.js"),
                    script.src("/assets/js/app.min.js").type("text/javascript"),
                    customScripts
                ),

                customHeader:
                link.href("https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0/katex.min.css").rel("stylesheet")
            ),
            withPath: \.base)
    }


    // Subviews
    struct TaskQuestionCardTemplate: ContextualTemplate {

        typealias Context = TaskPreviewContent

        func build() -> CompiledTemplate {
            return
                div.class("row").child(
                    div.class("col-12").child(

                        div.class("card d-block").child(
                            div.class("card-body").child(

                                p.class("text-secondary mb-2").child(

                                    renderIf(
                                        \.task.description != nil,
                                        variable(\.task.description, escaping: .unsafeNone)
                                    )
                                ),
                                h5.child(
                                    br,
                                    variable(\.task.question)
                                )
                            )
                        )
                    )
            )
        }
    }
}

