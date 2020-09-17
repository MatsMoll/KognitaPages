//
//  TaskCreateDraftTemplate.swift
//  KognitaViews
//
//  Created by Mats Mollestad on 03/09/2020.
//

import BootstrapKit

extension TypingTask.Templates.CreateDraft.Context {
    var modalTitle: String { content.subject.name + " | Lag tekstoppgave"}
    var subjectUri: String { "/subjects/\(content.subject.id)" }
    var subjectContentOverviewUri: String { "/creator/subjects/\(content.subject.id)/overview" }

    var isEditingTask: Bool { content.task != nil }

    var saveCall: String { "createDraft();" }

    var deleteCall: String? {
        guard let taskID = content.task?.id else {
            return nil
        }
        return "deleteTask(\(taskID), \"tasks/flash-card\");"
    }
}

extension TypingTask.Templates {

    public struct CreateDraft: HTMLTemplate {

        public struct Context {
            let user: User
            let content: TypingTask.ModifyContent

            public init(user: User, content: TypingTask.ModifyContent) {
                self.user = user
                self.content = content
            }
        }

        var breadcrumbs: [BreadcrumbItem] {
            [
                BreadcrumbItem(link: "/subjects", title: "Fagoversikt"),
                BreadcrumbItem(link: ViewWrapper(view: context.subjectUri), title: ViewWrapper(view: context.content.subjectName)),
                BreadcrumbItem(link: ViewWrapper(view: context.subjectContentOverviewUri), title: "Innholdsoversikt")
            ]
        }

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Lag oppgave", description: "Lag oppgave"))
            ) {
                PageTitle(title: "Lag tekstoppgave", breadcrumbs: breadcrumbs)
                FormCard(title: context.modalTitle) {

                    FormGroup {
                        TextArea {
                            Unwrap(context.content.task) {
                                $0.question
                            }
                        }
                        .class("form-control")
                        .id("card-question")
                        .placeholder("Noe å svare på her")
                        .required()
                    }
                    .customLabel {
                        Text { "Spørsmål" }
                            .style(.heading3)
                            .text(color: .dark)
                    }
                    .description {
                        Div { "Kun tillatt med bokstaver, tall, mellomrom og enkelte tegn (. , : ; ! ?)" }
                            .class("invalid-feedback")
                    }

                    FormGroup {
                        MarkdownEditor(id: "solution")
                            .placeholder("Gitt at funksjonen er konveks, fører det til at ...")
                    }
                    .customLabel {
                        Text { "Notater for løsningsforslag" }
                            .style(.heading3)
                            .text(color: .dark)
                    }

                    Text { "Velg Tema" }
                        .style(.heading3)
                        .text(color: .dark)

                    Unwrap(context.content.task) { task in
                        SubtopicPicker(
                            label: "Undertema",
                            idPrefix: "card-",
                            topics: context.content.topics
                        )
                        .selected(id: task.subtopicID)
                    }
                    .else {
                        SubtopicPicker(
                            label: "Undertema",
                            idPrefix: "card-",
                            topics: context.content.topics
                        )
                    }

                    DismissableError()

                    Button {
                        MaterialDesignIcon(icon: .check)
                        " Lagre"
                    }
                    .type(.button)
                    .button(style: .success)
                    .margin(.three, for: .vertical)
                    .on(click: context.saveCall)

                    Unwrap(context.deleteCall) { deleteCall in

                        Button {
                            MaterialDesignIcon(icon: .delete)
                            " Slett"
                        }
                        .type(.button)
                        .button(style: .danger)
                        .margin(.three, for: .vertical)
                        .margin(.one, for: .left)
                        .on(click: deleteCall)
                    }
                }
            }
            .header {
                Stylesheet(url: "/assets/css/vendor/simplemde.min.css")
                Stylesheet(url: "/assets/css/vendor/katex.min.css")
            }
            .scripts {
                Script(source: "/assets/js/vendor/simplemde.min.js")
                Script(source: "/assets/js/vendor/marked.min.js")
                Script(source: "/assets/js/vendor/katex.min.js")
                Script(source: "/assets/js/markdown-renderer.js")
                Script(source: "/assets/js/markdown-editor.js")
                Script(source: "/assets/js/dismissable-error.js")
                Script(source: "/assets/js/delete-task.js")
                Script(source: "/assets/js/flash-card/draft/json-data.js")
                IF(context.isEditingTask) {
                    Script(source: "/assets/js/flash-card/edit.js")
                }.else {
                    Script(source: "/assets/js/flash-card/draft/create.js")
                }
            }
        }
    }
}
