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

            let isResult: Bool
            var hasBeenCompleted: Bool { return previewContext.lastResult?.sessionId == (try? session?.requireID()) }

            var task: Task { return previewContext.task }
            var session: PracticeSessionRepresentable? { return previewContext.session }

            public init(
                multiple: MultipleChoiseTask.Data,
                taskContent: TaskPreviewContent,
                user: UserContent,
                currentTaskIndex: Int,
                session: PracticeSessionRepresentable,
                lastResult: TaskResultContent?,
                practiceProgress: Int,
                selectedChoises: [MultipleChoiseTaskChoise.Result] = []
            ) {
                self.previewContext = .init(
                    task: taskContent,
                    user: user,
                    practiceProgress: practiceProgress,
                    session: session,
                    taskPath: "multiple-choise",
                    currentTaskIndex: currentTaskIndex,
                    lastResult: lastResult
                )
                self.multipleChoiseTask = multiple
                self.isResult = !selectedChoises.isEmpty
                self.choises = multiple.choises.map { .init(choise: $0, selectedChoises: selectedChoises) }
            }
        }

        public init() {}

        public let context: TemplateValue<Context> = .root()

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

        struct ChoiseOption: HTMLComponent {

            let canSelectMultiple: Conditionable
            let choise: TemplateValue<ChoiseContext>

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
