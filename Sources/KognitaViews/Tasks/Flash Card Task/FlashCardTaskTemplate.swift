//
//  FlashCardTaskTemplate.swift
//  App
//
//  Created by Mats Mollestad on 31/03/2019.
//

import HTMLKit
import KognitaCore

public class FlashCardTaskTemplate: LocalizedTemplate {

    public init() {}

    public static var localePath: KeyPath<FlashCardTaskTemplate.Context, String>? = \.locale

    public enum LocalizationKeys: String {
        case answerButton = "exercise.answer.button"
        case solutionButton = "exercise.solution.button"
        case nextButton = "exercise.next.button"
        case stopSessionButton = "exercise.stop.button"
    }

    public struct Context {
        let locale = "nb"
        let taskPreview: TaskPreviewTemplate.Context
        var nextTaskIndex: Int?
        var prevTaskIndex: Int?

        var session: PracticeSession? { return taskPreview.session }
        var task: Task { return taskPreview.task }
        var topic: Topic { return taskPreview.topic }
        var hasBeenCompleted: Bool { return taskPreview.lastResult?.sessionId == session?.id }

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

    public func build() -> CompiledTemplate {
        return
            embed(
                TaskPreviewTemplate(
                    actionCard:
                    div.class("card").child(
                        div.class("card-body").child(
                            h4.class("mt-0 mb-3").child(
                                "Tenk på svaret og sjekk om du har riktig"
                            ),

                            // Submit button
                            button.type("button").onclick("revealSolution();").class("btn btn-success mr-1").id("submitButton").child(
                                i.class("mdi mdi-send mr-1"),
                                localize(.answerButton)
                            ),

                            // Practice session Button
                            renderIf(
                                isNotNil: \.session,

                                button.class("btn btn-danger float-right ml-1").onclick("submitAndEndSession();").child(
                                    localize(.stopSessionButton)
                                )
                            )
                        )
                    ),

                    customScripts: [
                        script.src("/assets/js/flash-card/submit-performance.js"),
                        script.src("/assets/js/practice-session-end.js"),
                        renderIf(
                            \.hasBeenCompleted,

                            script.child(
                                "window.onload = presentControlls;"
                            )
                        )
                    ],

                    underSolutionCard:
                    div.class("card d-none").id("knowledge-card").child(
                        div.class("card-body").child(

                            // Next button
                            renderIf(
                                isNotNil: \.nextTaskIndex,

                                input.id("next-task").type("hidden").value(variable(\.nextTaskIndex)),
                                button.class("btn btn-primary float-right").onclick("nextTask();").child(
                                    i.class("mdi mdi-play mr-1"),
                                    localize(.nextButton)
                                )
                            ),

                            // Prev button
                            renderIf(
                                isNotNil: \.prevTaskIndex,
                                a.href(variable(\.prevTaskIndex)).child(
                                    button.class("btn btn-secondary float-right mr-2").child(
                                        i.class("mdi mdi-play mr-1"),
                                        localize(.nextButton)
                                    )
                                )
                            ),

                            h4.class("mt-0 mb-3").child(
                                "Hvordan gikk det?"
                            ),

                            div.class("row no-gutter").child(
                                p.class("col-4 text-left h5").child(
                                    "😒" + br + "Har ikke kontroll"
                                ),

                                p.class("col-4 text-center h5").child(
                                    "😅", br, "Har litt kontroll"
                                ),

                                p.class("col-4 text-right h5").child(
                                    "🧐", br, "Har full kontroll"
                                )
                            ),

                            input.class("custom-range")
                                .id("knowledge-slider")
                                .type("range")
                                .name("range")
                                .min(0)
                                .max(4)
                                .value(2)


                            //                    button.type("button").onclick("presentHint();").class("btn btn-info mr-1").child(
                            //                        i.class("mdi mdi-help mr-1"),
                            //                        "Trenger du et hint?"
                            //                    ),
                        ),
                        
                        AchievementPopup()
                    )
                ),
                withPath: \.taskPreview
        )

    }
}
