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
        .padding(.five, for: .top)
    }

    func title(color: BootstrapStyle) -> FormCard {
        .init(title: title, formBody: formBody, titleColor: titleColor)
    }
}

extension FlashCardTask.Templates {
    public struct Create: TemplateView {

        public struct Context {
            let user: User
            let subject: Subject
            let topics: [Topic.Response]

            // Used to edit a task
            let taskInfo: Task?

            public init(user: User, subject: Subject, topics: [Topic.Response], content: Task? = nil, selectedTopicId: Int? = nil) {
                self.user = user
                self.subject = subject
                self.topics = topics
//                let sortSelectedTopicId = selectedTopicId ?? content?.subtopicId
//                self.topics = .init(topics: topics, selectedSubtopicId: sortSelectedTopicId)
                self.taskInfo = content
            }
        }

        public init() {}

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Lag Oppgave", description: "Lag Oppgave"))
            ) {
                FormCard(title: context.subject.name + " | Lag innskrivningsoppgave") {
                    Unwrap(context.taskInfo) { taskInfo in
                        IF(taskInfo.deletedAt.isDefined) {
                            Badge { "Slettet" }
                                .background(color: .danger)
                        }
                    }

                    SubtopicPicker(
                        label: "Undertema",
                        idPrefix: "card-",
                        topics: context.topics
                    )

                    FormRow {
                        FormGroup(label: "Eksamensett semester") {
                            Select {
                                Unwrap(context.taskInfo) { taskInfo in
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
                                .value(Unwrap(context.taskInfo) { $0.examPaperYear })
                        }
                        .column(width: .six, for: .medium)
                    }

                    FormGroup(label: "Oppgavetext") {
                        Div {
                            Unwrap(context.taskInfo) {
                                $0.description
                                    .escaping(.unsafeNone)
                            }
                        }
                        .id("card-description")
                    }

                    FormGroup(label: "Spørsmål") {
                        TextArea {
                            Unwrap(context.taskInfo) {
                                $0.question
                            }
                        }
                        .class("form-control")
                        .id("card-question")
                        .placeholder("Noe å svare på her")
                        .required()
                    }
                    .description {
                        Div {
                            "Bare lov med store og små bokstaver, tall, mellomrom + (. , : ; !, ?)"
                        }
                        .class("invalid-feedback")
                    }

                    FormGroup(label: "Løsning") {
                        Div()
                            .id("card-solution")
                    }

                    DismissableError()

                    Button {
                        Italic().class("mdi mdi-save")
                        " Lagre"
                    }
                    .type(.button)
                    .button(style: .success)
                    .margin(.three, for: .vertical)
                    .on(click:
                        IF(context.taskInfo.isDefined) {
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
                IF(context.taskInfo.isDefined) {
                    Script().source("/assets/js/flash-card/edit.js")
                }.else {
                    Script().source("/assets/js/flash-card/create.js")
                }
            }
        }
    }
}
