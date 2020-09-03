//
//  MultipleChoiceTask.swift
//  App
//
//  Created by Mats Mollestad on 27/02/2019.
//

import BootstrapKit

extension MultipleChoiceTask {
    public struct Templates {}
}

extension MultipleChoiceTask.Templates {
    public struct Execute: TemplateView {

        public struct Context {
            let previewContext: TaskPreviewTemplateContext
            let choises: [ChoiseContext]
            let multipleChoiceTask: MultipleChoiceTask

            let isResult: Bool
            var hasBeenCompleted: Bool { return previewContext.lastResult?.sessionID == sessionID }

            var task: Task { return previewContext.task }
            var sessionID: PracticeSession.ID { previewContext.sessionID }

            public init(
                multiple: MultipleChoiceTask,
                taskContent: TaskPreviewContent,
                user: User,
                currentTaskIndex: Int,
                sessionID: PracticeSession.ID,
                lastResult: TaskResult?,
                practiceProgress: Int,
                selectedChoises: [MultipleChoiceTaskChoice.ID] = [],
                numberOfTaskGoal: Int
            ) {
                self.previewContext = .init(
                    task: taskContent,
                    user: user,
                    practiceProgress: practiceProgress,
                    sessionID: sessionID,
                    taskPath: "multiple-choise",
                    currentTaskIndex: currentTaskIndex,
                    lastResult: lastResult,
                    numberOfTaskGoal: numberOfTaskGoal
                )
                self.multipleChoiceTask = multiple
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
                            canSelectMultiple: context.multipleChoiceTask.isMultipleSelect,
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
            let choise: MultipleChoiceTaskChoice

            init(choise: MultipleChoiceTaskChoice, selectedChoises: [MultipleChoiceTaskChoice.ID] = []) {
                self.isSelected = selectedChoises.contains(choise.id)
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
                                choise.choise.choice
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
