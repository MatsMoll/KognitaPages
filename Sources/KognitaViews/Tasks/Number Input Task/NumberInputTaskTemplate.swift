//
//  NumberInputTaskTemplate.swift
//  App
//
//  Created by Mats Mollestad on 20/03/2019.
//

import HTMLKit
import KognitaCore

public struct NumberInputTaskTemplate: LocalizedTemplate {

    public init() {}

    public static var localePath: KeyPath<NumberInputTaskTemplate.Context, String>? = \.locale

    public enum LocalizationKeys: String {
        case answerButton = "exercise.answer.button"
        case solutionButton = "exercise.solution.button"
        case nextButton = "exercise.next.button"
        case stopSessionButton = "exercise.stop.button"
    }

    public struct Context {
        let locale = "nb"
        let taskPreview: TaskPreviewTemplate.Context
        let numberTask: NumberInputTask
        var nextTaskIndex: Int?
        var prevTaskIndex: Int?

        var session: PracticeSession? { return taskPreview.session }
        var task: Task { return taskPreview.task }
        var topic: Topic { return taskPreview.topic }

        public init(
            numberTask: NumberInputTask,
            taskPreview: TaskPreviewContent,
            user: User,
            currentTaskIndex: Int?,
            session: PracticeSession? = nil,
            practiceProgress: Int? = nil,
            lastResult: TaskResultContent? = nil
//            numberOfTasks: Int
        ) {
            self.taskPreview = .init(
                task: taskPreview,
                user: user,
                practiceProgress: practiceProgress,
                session: session,
                lastResult: lastResult,
                taskPath: "input"
//                numberOfTasks: numberOfTasks
            )

            if let currentTaskIndex = currentTaskIndex {
                if currentTaskIndex > 1 {
                    self.prevTaskIndex = currentTaskIndex - 1
                }
                self.nextTaskIndex = currentTaskIndex + 1
            }
            self.numberTask = numberTask
        }
    }

    public func build() -> CompiledTemplate {
        return
            embed(
                TaskPreviewTemplate(
                    actionCard:
                    div.class("card").child(
                        div.class("card-body").child(
                            h4.class("mt-0 mb-3").child(
                                variable(\.taskPreview.taskContent.actionDescription)
                            ),

                            div.class("form-row").child(
                                div.class("form-group col-10").child(
                                    input.type("number").name("input").id("answer").class("form-control")
                                ),
                                div.class("form-group col-2").child(
                                    p.child(
                                        variable(\.numberTask.unit)
                                    )
                                )
                            ),
                            small.child(
                                "Skal du skrive desimaltall må det brukes \",\" eks. 2,5. Punktum og mellomrom vil bli ignorert. Altså 10.000 og 10 000 vil bli tolka som 10000"
                            ),
                            br,

                            // Submit button
                            button.type("button").onclick("submitAnswer();").class("btn btn-success mr-1").id("submitButton").child(
                                i.class("mdi mdi-send mr-1"),
                                localize(.answerButton)
                            ),

                            // Solution Button
                            renderIf(
                                \.task.solution != nil,

                                a.id("solution-button").class("d-none").href("#solution").child(
                                    button.type("button").class("btn btn-success mr-1").child(
                                        localize(.solutionButton)
                                    )
                                )
                            ),

                            // Practice session Button
                            renderIf(
                                isNotNil: \.session,

                                button.class("btn btn-danger float-right ml-1").onclick("endSession();").child(
                                    localize(.stopSessionButton)
                                )
                            ),
                            //                    button.type("button").onclick("presentHint();").class("btn btn-info mr-1").child(
                            //                        i.class("mdi mdi-help mr-1"),
                            //                        "Trenger du et hint?"
                            //                    ),

                            // Prev button
                            renderIf(
                                isNotNil: \.prevTaskIndex,

                                a.id("prevButton").href(variable(\.prevTaskIndex)).class("float-right d-none").child(
                                    button.type("button").class("btn btn-secondary").child(
                                        i.class("mdi mdi-play mr-1"),
                                        localize(.nextButton)
                                    )
                                )
                            ),

                            // Next button
                            renderIf(
                                isNotNil: \.nextTaskIndex,

                                a.id("nextButton").href(variable(\.nextTaskIndex)).class("float-right d-none").child(
                                    button.type("button").class("btn btn-primary").child(
                                        i.class("mdi mdi-play mr-1"),
                                        localize(.nextButton)
                                    )
                                )
                            )
                        ),
                        
                        AchievementPopup()
                    ),

                    customScripts: [
                        script.src("/assets/js/input/submit-answer.js"),
                        script.src("/assets/js/practice-session-end.js")
                    ]
                ),
                withPath: \.taskPreview)

    }
}
