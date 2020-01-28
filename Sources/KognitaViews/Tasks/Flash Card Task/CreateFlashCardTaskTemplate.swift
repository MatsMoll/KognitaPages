//
//  CreateFlashCardTaskTemplate.swift
//  App
//
//  Created by Mats Mollestad on 31/03/2019.
//

import BootstrapKit
import KognitaCore

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

extension FlashCardTask.Templates.Create.Context {
    var modalTitle: String { content.subject.name + " | Lag tekst oppgave"}
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
}

extension FlashCardTask.ModifyContent {
    var subjectName: String { subject.name }
}

extension FlashCardTask.Templates {
    public struct Create: TemplateView {

        public struct Context {
            let user: User
            let content: FlashCardTask.ModifyContent

            public init(user: User, content: FlashCardTask.ModifyContent) {
                self.user = user
                self.content = content
            }
        }

        var breadcrumbs: [BreadcrumbItem] {
            [
                BreadcrumbItem(link: "/subjects", title: "Fag oversikt"),
                BreadcrumbItem(link: ViewWrapper(view: context.subjectUri), title: ViewWrapper(view: context.content.subjectName)),
                BreadcrumbItem(link: ViewWrapper(view: context.subjectContentOverviewUri), title: "Innholds oversikt")
            ]
        }

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Lag Oppgave", description: "Lag Oppgave"))
            ) {
                PageTitle(title: "Lag tekst oppgave", breadcrumbs: breadcrumbs)
                FormCard(title: context.modalTitle) {
                    Unwrap(context.content.task) { task in
                        IF(task.isDeleted) {
                            Badge { "Slettet" }
                                .background(color: .danger)
                        }
                    }

                    Text {
                        "Velg Tema"
                    }
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

                    Text {
                        "Eksamens oppgave?"
                    }
                    .style(.heading3)
                    .text(color: .dark)

                    FormRow {
                        FormGroup(label: "Eksamensett semester") {
                            Select {
                                Unwrap(context.content.task) { taskInfo in
                                    Unwrap(taskInfo.examPaperSemester) { exam in
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
                                .value(Unwrap(context.content.task) { $0.examPaperYear })
                        }
                        .column(width: .six, for: .medium)
                    }

                    FormGroup {
                        Div {
                            Unwrap(context.content.task) {
                                $0.description
                                    .escaping(.unsafeNone)
                            }
                        }
                        .id("card-description")
                    }
                    .customLabel {
                        Text {
                            "Oppgavetekst"
                        }
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
                        Text {
                            "Spørsmål"
                        }
                        .style(.heading3)
                        .text(color: .dark)
                    }
                    .description {
                        Div {
                            "Kun tillatt med bokstaver, tall, mellomrom og enkelte tegn (. , : ; ! ?)"
                        }
                        .class("invalid-feedback")
                    }

                    FormGroup {
                        Div {
                            Unwrap(context.content.task) { task in
                                task.solution
                                    .escaping(.unsafeNone)
                            }
                        }
                            .id("card-solution")
                    }
                    .customLabel {
                        Text {
                            "Løsningsforslag"
                        }
                        .style(.heading3)
                        .text(color: .dark)
                    }

                    DismissableError()

                    Button {
                        MaterialDesignIcon(icon: .save)
                        " Lagre"
                    }
                    .type(.button)
                    .button(style: .success)
                    .margin(.three, for: .vertical)
                    .on(click:
                        IF(context.isEditingTask) {
                            "editFlashCard();"
                        }.else {
                            "createFlashCard();"
                        }
                    )
                }
            }
            .header {
                Link().href("/assets/css/vendor/summernote-bs4.css").relationship(.stylesheet).type("text/css")
                Link().href("https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0/katex.min.css").relationship(.stylesheet)
            }
            .scripts {
                Script().source("/assets/js/vendor/summernote-bs4.min.js")
                Script().source("https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0/katex.min.js")
                Script().source("/assets/js/vendor/summernote-math.js")
                Script().source("/assets/js/dismissable-error.js")
                Script().source("/assets/js/flash-card/json-data.js")
                IF(context.isEditingTask) {
                    Script().source("/assets/js/flash-card/edit.js")
                }.else {
                    Script().source("/assets/js/flash-card/create.js")
                }
            }
        }
    }
}
