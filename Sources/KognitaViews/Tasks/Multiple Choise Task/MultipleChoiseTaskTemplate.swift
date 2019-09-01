//
//  MultipleChoiseTask.swift
//  App
//
//  Created by Mats Mollestad on 27/02/2019.
//

import HTMLKit
import KognitaCore

extension AttributableNode {

    func ariaControls(_ value: CompiledTemplate...) -> Self {
        return add(.init(attribute: "aria-controls", value: value))
    }

    func dataParent(_ value: CompiledTemplate...) -> Self {
        return add(.init(attribute: "data-parent", value: value))
    }
}

public struct MultipleChoiseTaskTemplate: LocalizedTemplate {

    public init() {}

    public static var localePath: KeyPath<MultipleChoiseTaskTemplate.Context, String>? = \.locale

    public enum LocalizationKeys: String {
        case answerTitle = "exercise.multiple.choice.answer.title"
        case answerButton = "exercise.answer.button"
        case solutionButton = "exercise.solution.button"
        case nextButton = "exercise.next.button"
        case stopSessionButton = "exercise.stop.button"
    }

    public struct Context {
        let locale = "nb"
        let previewContext: TaskPreviewTemplate.Context
        let choises: [SingleChoiseOption.Context]
        let multipleChoiseTask: MultipleChoiseTask.Data

        let nextTaskPath: String?
        let isResult: Bool

        var task: Task { return previewContext.task }
        var session: PracticeSession? { return previewContext.session }

        public init(
            multiple: MultipleChoiseTask.Data,
            taskContent: TaskPreviewContent,
            user: User,
            selectedChoises: [MultipleChoiseTaskChoise.Result] = [],
            nextTaskPath: String? = nil,
            session: PracticeSession? = nil,
            practiceProsess: Int? = nil,
            lastResult: TaskResultContent? = nil,
            numberOfTasks: Int
        ) {
            self.previewContext = .init(
                task: taskContent,
                user: user,
                practiceProgress: practiceProsess,
                session: session,
                lastResult: lastResult,
                taskPath: "multiple-choise",
                numberOfTasks: numberOfTasks
            )
            self.multipleChoiseTask = multiple
            self.isResult = !selectedChoises.isEmpty
            self.choises = multiple.choises.map { .init(choise: $0, selectedChoises: selectedChoises) }
            self.nextTaskPath = nextTaskPath
        }
    }


    public func build() -> CompiledTemplate {
        return embed(
            TaskPreviewTemplate(
                actionCard:

                div.class("card").child(
                    div.class("card-body").child(
                        h4.class("mt-0 mb-3").child(
                            localize(.answerTitle)
                        ),

                        // Choises
                        renderIf(
                            \.multipleChoiseTask.isMultipleSelect,

                            forEach(in:     \.choises,
                                    render: MultipleChoiseOption()
                            )
                        ).else(
                            forEach(in:     \.choises,
                                    render: SingleChoiseOption()
                            )
                        ),

                        // Submit button
                        renderIf(
                            \.isResult == false,

                            button.type("button").onclick("submitChoises();").class("btn btn-success mr-1").id("submitButton").child(
                                i.class("mdi mdi-send mr-1"),
                                localize(.answerButton)
                            )
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

                        // Next button
                        renderIf(
                            isNotNil: \.nextTaskPath,

                            a.id("nextButton").href(variable(\.nextTaskPath)).class("float-right d-none").child(
                                button.type("button").class("btn btn-primary").child(
                                    i.class("mdi mdi-play mr-1"),
                                    "Neste"
                                )
                            )
                        ),
                        
                        AchievementPopup()
                    )
                ),

                customScripts: [
                    script.src("/assets/js/task-submit.js"),
                    script.src("/assets/js/practice-session-end.js")
                ]
            ),
            withPath: \.previewContext)
    }


    // MARK: - Subviews

    struct SingleChoiseOption: ContextualTemplate {

        struct Context {
            let isSelected: Bool
            let isCorrect: Bool
            let choise: MultipleChoiseTaskChoise

            init(choise: MultipleChoiseTaskChoise, selectedChoises: [MultipleChoiseTaskChoise.Result] = []) {
                let selectedIndex = selectedChoises.firstIndex(where: { $0.id == choise.id })
                if let selectedIndex = selectedIndex {
                    self.isCorrect = selectedChoises[selectedIndex].isCorrect
                } else {
                    self.isCorrect = false
                }
                self.isSelected = selectedIndex != nil
                self.choise = choise
            }
        }

        func build() -> CompiledTemplate {
            return
                div.class("card mb-1 shadow-none border").child(
                    div.class("p-2 text-secondary").id(variable(\.choise.id), "-div").child(

                        div.class("custom-control custom-radio").child(

                            input.type("radio").name("choiseInput").class("custom-control-input").id(variable(\.choise.id))

                                // If results add needed classes
                                .if(\.isSelected,                           add: .class("text-white"), .selected)
                                .if(\.isSelected && \.isCorrect == true,    add: .class("bg-success"))
                                .if(\.isSelected && \.isCorrect == false,   add: .class("bg-danger")
                            ),
                            label.class("custom-control-label").for(variable(\.choise.id)).child(
                                variable(\.choise.choise, escaping: .unsafeNone)
                            )
                        )
                    )
            )
        }

    }

    struct MultipleChoiseOption: ContextualTemplate {

        typealias Context = SingleChoiseOption.Context

        func build() -> CompiledTemplate {
            return
                div.class("card mb-1 shadow-none border").child(
                    div.class("p-2 text-secondary").id(variable(\.choise.id), "-div").child(

                        div.class("custom-control custom-checkbox").child(
                            input.type("checkbox").name("choiseInput").class("custom-control-input").id(variable(\.choise.id))

                                // If results add needed classes
                                .if(\.isSelected,                           add: .class("text-white"), .selected)
                                .if(\.isSelected && \.isCorrect == true,    add: .class("bg-success"))
                                .if(\.isSelected && \.isCorrect == false,   add: .class("bg-danger")
                            ),
                            label.class("custom-control-label").for(variable(\.choise.id)).child(
                                variable(\.choise.choise, escaping: .unsafeNone)
                            )
                        )
                    )
            )
        }
    }
}
