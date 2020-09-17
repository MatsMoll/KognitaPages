//
//  CreateFlashCardTaskTemplate.swift
//  App
//
//  Created by Mats Mollestad on 31/03/2019.
//

import BootstrapKit

struct FormCard: HTMLComponent {

    let title: HTML
    private let titleColor: BootstrapStyle
    let formBody: HTML

    init(title: HTML, @HTMLBuilder body: () -> HTML) {
        self.title = title
        self.formBody = body()
        self.titleColor = .primary
    }

    private init(title: HTML, formBody: HTML, titleColor: BootstrapStyle) {
        self.title = title
        self.formBody = formBody
        self.titleColor = titleColor
    }

    var body: HTML {
        Div {
            Div {
                Text {
                    title
                }
                .class("modal-title")
                .id("create-modal-label")
                .style(.heading4)
            }
            .class("modal-header")
            .text(color: .white)
            .background(color: titleColor)

            Div {
                Div {
                    Form {
                        formBody
                    }
                }
                .padding(.two)
            }
            .class("modal-body")
        }
        .class("card")
    }

    func title(color: BootstrapStyle) -> FormCard {
        .init(title: title, formBody: formBody, titleColor: titleColor)
    }
}

extension TypingTask.Templates.Create.Context {
    var modalTitle: String { content.subject.name + " | Lag tekstoppgave"}
    var subjectUri: String { "/subjects/\(content.subject.id)" }
    var subjectContentOverviewUri: String { "/creator/subjects/\(content.subject.id)/overview" }

    var isTestable: Bool {
        guard let task = content.task else {
            return false
        }
        return task.isTestable
    }

    var isEditingTask: Bool {
        content.task != nil
    }

    var saveCall: String {
        if isEditingTask {
            return "editFlashCard();"
        } else {
            return "createFlashCard();"
        }
    }

    var deleteCall: String? {
        guard let taskID = content.task?.id else {
            return nil
        }
        return "deleteTask(\(taskID), \"tasks/flash-card\");"
    }
}

extension TypingTask.ModifyContent {
    var subjectName: String { subject.name }
}

extension TypingTask.Templates {
    public struct Create: TemplateView {

        public struct Context {
            let user: User
            let content: TypingTask.ModifyContent
            let wasUpdated: Bool
            let canEdit: Bool

            public init(user: User, content: TypingTask.ModifyContent, canEdit: Bool, wasUpdated: Bool = false) {
                self.user = user
                self.content = content
                self.canEdit = canEdit
                self.wasUpdated = wasUpdated
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
                IF(context.wasUpdated) {
                    Alert {
                        "Endringene ble lagret"
                    }
                    .background(color: .success)
                    .text(color: .white)
                    .isDismissable(true)
                }
                FormCard(title: context.modalTitle) {
                    Unwrap(context.content.task) { task in
                        IF(task.isDeleted) {
                            Badge { "Slettet" }
                                .background(color: .danger)
                        }
                    }

                    FormGroup {
                        MarkdownEditor(id: "description") {
                            Unwrap(context.content.task) {
                                $0.description
                                    .escaping(.unsafeNone)
                            }
                        }
                        .placeholder("Du har gitt en funksjon ...")
                    }
                    .customLabel {
                        Text { "Innledning" }
                            .style(.heading3)
                            .text(color: .dark)
                    }

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

                    Unwrap(context.content.task) { task in
                        IF(task.solutions.count > 1) {
                            TaskSolutionCard(fetchUrl: Script.fetchSolutionEditorUrl)
                        }.else {
                            Unwrap(task.solutions.first) { solution in
                                solutionForm(solution)
                            }
                        }
                    }.else {
                        solutionForm()
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

                    Text { "Eksamensoppgave?" }
                    .style(.heading3)
                    .text(color: .dark)

                    FormRow {
                        FormGroup(label: "Eksamensett semester") {
                            Select {
                                Unwrap(context.content.task) { taskInfo in
                                    Unwrap(taskInfo.examType) { exam in
                                        Option {
                                            exam.rawValue
                                        }
                                        .value(exam.rawValue)
                                    }
                                }
                                Option { "Ikke eksamensoppgave" }
                                    .value("")
                                Option { "Høst" }
                                    .value("fall")
                                Option { "Vår" }
                                    .value("spring")
                            }
                            .id("card-exam-semester")
                            .class("select2")
                            .data(for: "toggle", value: "select2")
                            .data(for: "placeholder", value: "Velg ...")
                        }
                        .column(width: .six, for: .medium)

                        FormGroup(label: "År") {
                            Input()
                                .type(.number)
                                .id("card-exam-year")
                                .placeholder("2019")
                                .value(Unwrap(context.content.task) { $0.examYear })
                        }
                        .column(width: .six, for: .medium)
                    }

                    DismissableError()

                    IF(context.canEdit) {
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
                Script(source: "/assets/js/flash-card/json-data.js")
                IF(context.isEditingTask) {
                    Script(source: "/assets/js/flash-card/edit.js")
                }.else {
                    Script(source: "/assets/js/flash-card/create.js")
                }
            }
        }

        private func solutionForm(content: HTML = "", id: HTML = "solution") -> HTML {
            FormGroup {
                MarkdownEditor(id: id) { content }
                    .placeholder("Gitt at funksjonen er konveks, fører det til at ...")
                    .onChange { editor in
                        Script.solutionScore(divID: "solution-req", editorName: editor)
                }
            }
            .customLabel {
                Text { "Løsningsforslag" }
                    .style(.heading3)
                    .text(color: .dark)
            }
            .description {
                TaskSolution.Templates.Requmendations().id("solution-req")
            }
        }

        private func solutionForm(_ solution: TemplateValue<TaskSolution>) -> HTML {
            solutionForm(content: solution.solution.escaping(.unsafeNone))
        }
    }
}
