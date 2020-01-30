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
            var hasBeenCompleted: Bool { return previewContext.lastResult?.sessionId == (try? session?.requireID()) }

            var task: Task { return previewContext.task }
            var session: PracticeSessionRepresentable? { return previewContext.session }

            public init(
                multiple: MultipleChoiseTask.Data,
                taskContent: TaskPreviewContent,
                user: UserContent,
                selectedChoises: [MultipleChoiseTaskChoise.Result] = [],
                currentTaskIndex: Int? = nil,
                session: PracticeSessionRepresentable? = nil,
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

                    Unwrap(context.session) { session in
                        Form {
                            Button(Strings.exerciseStopSessionButton)
                                .button(style: .danger)
                                .float(.right)
                                .margin(.one, for: .left)
                        }
                        .action("/practice-sessions/" + session.id + "/end")
                        .method(.post)
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
