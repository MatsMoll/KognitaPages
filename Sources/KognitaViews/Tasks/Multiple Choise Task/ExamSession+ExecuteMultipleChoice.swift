//
//  ExamSession+ExecuteMultipleChoice.swift
//  KognitaCore
//
//  Created by Mats Mollestad on 07/11/2020.
//

import BootstrapKit

extension ExamSession {
    public enum Templates {}
}

extension ExamSession.Templates {
    public struct ExecuteMultipleChoice: TemplateView {

        public struct Context {
            let previewContext: TaskPreviewTemplateContext
            let choises: [MultipleChoiceTask.Templates.ChoiceContext]
            let multipleChoiceTask: MultipleChoiceTask

            let isResult: Bool
            var hasBeenCompleted: Bool { return previewContext.lastResult?.sessionID == sessionID }

            var task: Task { return previewContext.task }
            var sessionID: Sessions.ID { previewContext.sessionID }

            public init(
                multiple: MultipleChoiceTask,
                taskContent: TaskPreviewContent,
                user: User,
                lastResult: TaskResult?,
                selectedChoises: [MultipleChoiceTaskChoice.ID] = [],
                progressState: Sessions.ProgressState
            ) {
                self.previewContext = .init(
                    task: taskContent,
                    progressState: progressState,
                    user: user,
                    taskPath: "multiple-choise",
                    lastResult: lastResult
                )
                self.multipleChoiceTask = multiple
                self.isResult = !selectedChoises.isEmpty
                self.choises = multiple.choises.map { .init(choice: $0, selectedChoises: selectedChoises) }
            }
        }

        public init() {}

        public let context: TemplateValue<Context> = .root()

        public var body: HTML {
            TaskPreviewTemplate(context: context.previewContext, sessionType: .exam) {

                Card {
                    Text { context.previewContext.taskContent.actionDescription }
                        .style(.heading5)
                        .margin(.zero, for: .top)

                    ForEach(in: context.choises) { choice in
                        MultipleChoiceTask.Templates.ChoiceOption(
                            hasBeenAnswered: context.hasBeenCompleted,
                            canSelectMultiple: context.multipleChoiceTask.isMultipleSelect,
                            choice: choice
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
                IF(context.hasBeenCompleted) {
                    Script { "window.onload = presentControlls;" }
                }
            }
        }
    }
}
