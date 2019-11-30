//
//  MultipleChoiseTask.swift
//  App
//
//  Created by Mats Mollestad on 27/02/2019.
//

import BootstrapKit
import KognitaCore

extension MultipleChoiseTask {
    public struct Templates {}
}

extension MultipleChoiseTask.Templates {
    public struct Execute: TemplateView {

        public struct Context {
            let previewContext: TaskPreviewTemplateContext
            let choises: [ChoiseContext]
            let multipleChoiseTask: MultipleChoiseTask.Data

            var nextTaskIndex: Int?
            var prevTaskIndex: Int?
            let isResult: Bool
            var hasBeenCompleted: Bool { return previewContext.lastResult?.sessionId == session?.id }

            var task: Task { return previewContext.task }
            var session: PracticeSession? { return previewContext.session }

            public init(
                multiple: MultipleChoiseTask.Data,
                taskContent: TaskPreviewContent,
                user: User,
                selectedChoises: [MultipleChoiseTaskChoise.Result] = [],
                currentTaskIndex: Int? = nil,
                session: PracticeSession? = nil,
                practiceProsess: Int? = nil,
                lastResult: TaskResultContent? = nil
            ) {
                self.previewContext = .init(
                    task: taskContent,
                    user: user,
                    practiceProgress: practiceProsess,
                    session: session,
                    lastResult: lastResult,
                    taskPath: "multiple-choise"
                )
                self.multipleChoiseTask = multiple
                self.isResult = !selectedChoises.isEmpty
                self.choises = multiple.choises.map { .init(choise: $0, selectedChoises: selectedChoises) }
                if let currentTaskIndex = currentTaskIndex {
                    if currentTaskIndex > 1 {
                        self.prevTaskIndex = currentTaskIndex - 1
                    }
                    self.nextTaskIndex = currentTaskIndex + 1
                }
            }
        }

        public init() {}

        public let context: RootValue<Context> = .root()

        public var body: HTML {
            TaskPreviewTemplate(context: context.previewContext) {
                Card {
                    ForEach(in: context.choises) { choise in
                        ChoiseOption(
                            canSelectMultiple: context.multipleChoiseTask.isMultipleSelect,
                            choise: choise
                        )
                    }

                    IF(context.isResult == false) {
                        Button {
                            Italic().class("mdi mdi-send mr-1")
                            Strings.exerciseAnswerButton
                                .localized()
                        }
                        .type(.button)
                        .on(click: "submitChoises();")
                        .button(style: .success)
                        .margin(.one, for: .right)
                        .id("submitButton")
                    }
                    Anchor {
                        Button(Strings.exerciseSolutionButton)
                            .type(.button)
                            .button(style: .success)
                            .margin(.one, for: .right)
                    }
                    .id("solution-button")
                    .display(.none)
                    .href("#solution")
                    IF(context.session.isDefined) {
                        Button(Strings.exerciseStopSessionButton)
                            .button(style: .danger)
                            .float(.right)
                            .margin(.one, for: .left)
                            .on(click: "endSession();")
                    }
                    IF(context.nextTaskIndex.isDefined) {
                        Anchor {
                            Button {
                                Strings.exerciseNextButton
                                    .localized()
                                Italic().class("mdi mdi-arrow-right ml-1")
                            }
                            .type(.button)
                            .button(style: .primary)
                        }
                        .id("nextButton")
                        .href(context.nextTaskIndex)
                        .display(.none)
                        .float(.right)
                        .margin(.one, for: .left)
                        .relationship(.next)
                    }
                    IF(context.prevTaskIndex.isDefined) {
                        Anchor {
                            Button {
                                Italic().class("mdi mdi-arrow-left mr-1")
                                "Forrige"
                            }
                            .type(.button)
                            .button(style: .light)
                        }
                        .id("prevButton")
                        .href(context.prevTaskIndex)
                        .float(.right)
                        .relationship(.prev)
                    }
                }
            }
            .scripts {
                Script().source("/assets/js/multiple-choise/task-submit.js")
                Script().source("/assets/js/practice-session-end.js")
                IF(context.hasBeenCompleted) {
                    Script {
                        "window.onload = presentControlls;"
                    }
                }
            }
        }

        struct ChoiseContext {
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

        struct ChoiseOption<T>: HTMLComponent {

            let canSelectMultiple: Conditionable
            let choise: TemplateValue<T, ChoiseContext>

            var body: HTML {
                Div {
                    Div {
                        Div {
                            Input()
                                .name("choiseInput")
                                .class("custom-control-input")
                                .id(choise.choise.id)
                                .modify(if: canSelectMultiple) {
                                    $0.type(.checkbox)
                                }
                                .modify(if: !canSelectMultiple) {
                                    $0.type(.radio)
                                }
                                .modify(if: choise.isSelected) { (isSelected: Input) in
                                    isSelected
                                        .text(color: .white)
                                        .modify(if: choise.isCorrect) { (isCorrect: Input) in
                                            isCorrect
                                                .background(color: .success)
                                        }
                                        .modify(if: !choise.isCorrect) { (isIncorrect: Input) in
                                            isIncorrect
                                                .background(color: .danger)
                                    }
                                }
                            Label {
                                choise.choise.choise
                                    .escaping(.unsafeNone)
                            }
                            .class("custom-control-label")
                            .for(choise.choise.id)
                        }
                        .class("custom-control")
                        .modify(if: canSelectMultiple) {
                            $0.class("custom-checkbox")
                        }
                        .modify(if: !canSelectMultiple) {
                            $0.class("custom-radio")
                        }
                    }
                    .class("p-2 text-secondary")
                    .id(choise.choise.id + "-div")
                }
                .class("card mb-1 shadow-none border")
            }
        }
    }
}

//public struct MultipleChoiseTaskTemplate: LocalizedTemplate {
//
//    public init() {}
//
//    public static var localePath: KeyPath<MultipleChoiseTaskTemplate.Context, String>? = \.locale
//
//    public enum LocalizationKeys: String {
//        case answerTitle = "exercise.multiple.choice.answer.title"
//        case answerButton = "exercise.answer.button"
//        case solutionButton = "exercise.solution.button"
//        case nextButton = "exercise.next.button"
//        case stopSessionButton = "exercise.stop.button"
//    }
//
//    public struct Context {
//        let locale = "nb"
//        let previewContext: TaskPreviewTemplate.Context
//        let choises: [SingleChoiseOption.Context]
//        let multipleChoiseTask: MultipleChoiseTask.Data
//
//        var nextTaskIndex: Int?
//        var prevTaskIndex: Int?
//        let isResult: Bool
//
//        var task: Task { return previewContext.task }
//        var session: PracticeSession? { return previewContext.session }
//
//        public init(
//            multiple: MultipleChoiseTask.Data,
//            taskContent: TaskPreviewContent,
//            user: User,
//            selectedChoises: [MultipleChoiseTaskChoise.Result] = [],
//            currentTaskIndex: Int? = nil,
//            session: PracticeSession? = nil,
//            practiceProsess: Int? = nil,
//            lastResult: TaskResultContent? = nil
////            numberOfTasks: Int
//        ) {
//            self.previewContext = .init(
//                task: taskContent,
//                user: user,
//                practiceProgress: practiceProsess,
//                session: session,
//                lastResult: lastResult,
//                taskPath: "multiple-choise"
////                numberOfTasks: numberOfTasks
//            )
//            self.multipleChoiseTask = multiple
//            self.isResult = !selectedChoises.isEmpty
//            self.choises = multiple.choises.map { .init(choise: $0, selectedChoises: selectedChoises) }
//            if let currentTaskIndex = currentTaskIndex {
//                if currentTaskIndex > 1 {
//                    self.prevTaskIndex = currentTaskIndex - 1
//                }
//                self.nextTaskIndex = currentTaskIndex + 1
//            }
//        }
//    }
//
//
//    public func build() -> CompiledTemplate {
//        return embed(
//            TaskPreviewTemplate(
//                actionCard:
//
//                div.class("card").child(
//                    div.class("card-body").child(
//
//                        // Choises
//                        renderIf(
//                            \.multipleChoiseTask.isMultipleSelect,
//
//                            forEach(in:     \.choises,
//                                    render: MultipleChoiseOption()
//                            )
//                        ).else(
//                            forEach(in:     \.choises,
//                                    render: SingleChoiseOption()
//                            )
//                        ),
//
//                        // Submit button
//                        renderIf(
//                            \.isResult == false,
//
//                            button.type("button").onclick("submitChoises();").class("btn btn-success mr-1").id("submitButton").child(
//                                i.class("mdi mdi-send mr-1"),
//                                localize(.answerButton)
//                            )
//                        ),
//
//                        // Solution Button
//                        renderIf(
//                            \.task.solution != nil,
//
//                            a.id("solution-button").class("d-none").href("#solution").child(
//                                button.type("button").class("btn btn-success mr-1").child(
//                                    localize(.solutionButton)
//                                )
//                            )
//                        ),
//
//                        // Practice session Button
//                        renderIf(
//                            isNotNil: \.session,
//
//                            button.class("btn btn-danger float-right ml-1").onclick("endSession();").child(
//                                localize(.stopSessionButton)
//                            )
//
//                        ),
//                        //                    button.type("button").onclick("presentHint();").class("btn btn-info mr-1").child(
//                        //                        i.class("mdi mdi-help mr-1"),
//                        //                        "Trenger du et hint?"
//                        //                    ),
//
//                        // Next button
//                        renderIf(
//                            isNotNil: \.nextTaskIndex,
//
//                            a.id("nextButton").href(variable(\.nextTaskIndex)).class("float-right ml-1 d-none").child(
//                                button.type("button").class("btn btn-primary").child(
//                                    "Neste",
//                                    i.class("mdi mdi-arrow-right ml-1")
//                                )
//                            )
//                        ),
//
//                        // Prev button
//                        renderIf(
//                            isNotNil: \.prevTaskIndex,
//
//                            a.id("prevButton").href(variable(\.prevTaskIndex)).class("float-right").child(
//                                button.type("button").class("btn btn-light").child(
//                                    i.class("mdi mdi-arrow-left mr-1"),
//                                    "Forrige"
//                                )
//                            )
//                        ),
//                        
//                        AchievementPopup()
//                    )
//                ),
//
//                customScripts: [
//                    script.src("/assets/js/task-submit.js"),
//                    script.src("/assets/js/practice-session-end.js")
//                ]
//            ),
//            withPath: \.previewContext)
//    }
//
//
//    // MARK: - Subviews
//
//    struct SingleChoiseOption: ContextualTemplate {
//
//        struct Context {
//            let isSelected: Bool
//            let isCorrect: Bool
//            let choise: MultipleChoiseTaskChoise
//
//            init(choise: MultipleChoiseTaskChoise, selectedChoises: [MultipleChoiseTaskChoise.Result] = []) {
//                let selectedIndex = selectedChoises.firstIndex(where: { $0.id == choise.id })
//                if let selectedIndex = selectedIndex {
//                    self.isCorrect = selectedChoises[selectedIndex].isCorrect
//                } else {
//                    self.isCorrect = false
//                }
//                self.isSelected = selectedIndex != nil
//                self.choise = choise
//            }
//        }
//
//        func build() -> CompiledTemplate {
//            return
//                div.class("card mb-1 shadow-none border").child(
//                    div.class("p-2 text-secondary").id(variable(\.choise.id), "-div").child(
//
//                        div.class("custom-control custom-radio").child(
//
//                            input.type("radio").name("choiseInput").class("custom-control-input").id(variable(\.choise.id))
//
//                                // If results add needed classes
//                                .if(\.isSelected,                           add: .class("text-white"), .selected)
//                                .if(\.isSelected && \.isCorrect == true,    add: .class("bg-success"))
//                                .if(\.isSelected && \.isCorrect == false,   add: .class("bg-danger")
//                            ),
//                            label.class("custom-control-label").for(variable(\.choise.id)).child(
//                                variable(\.choise.choise, escaping: .unsafeNone)
//                            )
//                        )
//                    )
//            )
//        }
//
//    }
//
//    struct MultipleChoiseOption: ContextualTemplate {
//
//        typealias Context = SingleChoiseOption.Context
//
//        func build() -> CompiledTemplate {
//            return
//                div.class("card mb-1 shadow-none border").child(
//                    div.class("p-2 text-secondary").id(variable(\.choise.id), "-div").child(
//
//                        div.class("custom-control custom-checkbox").child(
//                            input.type("checkbox").name("choiseInput").class("custom-control-input").id(variable(\.choise.id))
//
//                                // If results add needed classes
//                                .if(\.isSelected,                           add: .class("text-white"), .selected)
//                                .if(\.isSelected && \.isCorrect == true,    add: .class("bg-success"))
//                                .if(\.isSelected && \.isCorrect == false,   add: .class("bg-danger")
//                            ),
//                            label.class("custom-control-label").for(variable(\.choise.id)).child(
//                                variable(\.choise.choise, escaping: .unsafeNone)
//                            )
//                        )
//                    )
//            )
//        }
//    }
//}
