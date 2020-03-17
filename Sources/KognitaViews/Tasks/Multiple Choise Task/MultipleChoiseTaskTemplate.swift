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
                selectedChoises: [MultipleChoiseTaskChoise.ID] = []
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
                    Text {
                        context.previewContext.taskContent.actionDescription
                    }
                    .style(.heading5)
                    .margin(.zero, for: .top)

                    ForEach(in: context.choises) { choise in
                        ChoiseOption(
                            hasBeenAnswered: context.hasBeenCompleted,
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
                }
            }
            .scripts {
                Script().source("/assets/js/multiple-choise/task-submit.js")
                Script().source("/assets/js/practice-session-end.js")
                IF(context.hasBeenCompleted) {
                    Script { "window.onload = presentControlls;" }
                }
            }
        }

        struct ChoiseContext {
            let isSelected: Bool
            var isCorrect: Bool { choise.isCorrect }
            let choise: MultipleChoiseTaskChoise

            init(choise: MultipleChoiseTaskChoise, selectedChoises: [MultipleChoiseTaskChoise.ID] = []) {
                self.isSelected = selectedChoises.contains(choise.id ?? 0)
                self.choise = choise
            }
        }

        struct ChoiseOption: HTMLComponent {

            let hasBeenAnswered: Conditionable
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
                                .isChecked(choise.isSelected)
                                .modify(if: hasBeenAnswered) {
                                    $0.add(HTMLAttribute(attribute: "disabled", value: "disabled"))
                                }
                                .modify(if: canSelectMultiple) {
                                    $0.type(.checkbox)
                                }
                                .modify(if: !canSelectMultiple) {
                                    $0.type(.radio)
                                }
                            Label {
                                choise.choise.choise
                                    .escaping(.unsafeNone)
                            }
                            .class("custom-control-label")
                            .for(choise.choise.id)
                            .modify(if: hasBeenAnswered && (choise.isSelected || choise.isCorrect)) {
                                $0.text(color: .white)
                            }
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
                    .modify(if: hasBeenAnswered && choise.isCorrect) {
                        $0.background(color: .success)
                    }
                    .modify(if: choise.isSelected && !choise.isCorrect) {
                        $0.background(color: .danger)
                    }
                }
                .class("card mb-1 shadow-none border")
            }
        }
    }
}
