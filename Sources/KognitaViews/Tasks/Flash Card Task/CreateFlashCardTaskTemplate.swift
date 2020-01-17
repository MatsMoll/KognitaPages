//
//  CreateFlashCardTaskTemplate.swift
//  App
//
//  Created by Mats Mollestad on 31/03/2019.
//

import BootstrapKit
import KognitaCore

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

        public let context: TemplateValue<Context> = .root()

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Lag Oppgave", description: "Lag Oppgave"))
            ) {
                Div {
                    Div {
                        Div {
                            Text {
                                context.subject.name
                                " | Lag innskrivningsoppgave"
                            }
                            .class("modal-title")
                            .id("create-modal-label")
                            .style(.heading4)
                        }
                        .class("modal-header bg-" + context.subject.colorClass.rawValue)
                        .text(color: .white)

                        Div {
                            Div {
                                Form {

                                    Unwrap(context.taskInfo) { taskInfo in
                                        IF(taskInfo.deletedAt.isDefined) {
                                            Badge { "Inaktiv" }
                                                .background(color: .danger)
                                        }.else {
                                            Badge { "Godkjent" }
                                                .background(color: .success)
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

                                    FormGroup(label: "Oppgavetekst") {
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
//                                        .rows(1)
                                        .placeholder("Noe å svare på her")
                                        .required()
                                    }
                                    .description {
                                        Div {
                                            "Kun tillatt med bokstaver, tall, mellomrom og enkelte tegn (. , : ; ! ?)"
                                        }
                                        .class("invalid-feedback")
                                    }

                                    FormGroup(label: "Løsning") {
                                        Div {
                                            ""
//                                            Unwrap(context.taskInfo) {
//                                                $0.solution
//                                                    .escaping(.unsafeNone)
//                                            }
                                        }
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
                                .class("needs-validation")
                            }
                            .padding(.two)
                        }
                        .class("modal-body")
                    }
                    .class("card")
                }
                .padding(.five, for: .top)
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

//public class CreateFlashCardTaskTemplate: LocalizedTemplate {
//
//    public init() {}
//
//    public static var localePath: KeyPath<CreateFlashCardTaskTemplate.Context, String>? = \.locale
//
//    public enum LocalizationKeys: String {
//        case none
//    }
//
//    public struct Context {
//        let locale = "nb"
//        let base: ContentBaseTemplate.Context
//        let subject: Subject
//        let topics: SubtopicPicker.Context
//
//        // Used to edit a task
//        let taskInfo: Task?
//
//        public init(user: User, subject: Subject, topics: [Topic.Response], content: Task? = nil, selectedTopicId: Int? = nil) {
//            self.base = .init(user: user, title: "Lag Oppgave")
//            self.subject = subject
//            let sortSelectedTopicId = selectedTopicId ?? content?.subtopicId
//            self.topics = .init(topics: topics, selectedSubtopicId: sortSelectedTopicId)
//            self.taskInfo = content
//        }
//    }
//
//    public func build() -> CompiledTemplate {
//        return embed(
//            ContentBaseTemplate(
//                body:
//
//                div.class("pt-5").child(
//
//                    div.class("card").child(
//                        div.class("modal-header text-white bg-" + variable(\.subject.colorClass.rawValue)).child(
//                            h4.class("modal-title").id("create-modal-label").child(
//                                variable(\.subject.name), " | Lag innskrivningsoppgave"
//                            )
//                        ),
//                        div.class("modal-body").child(
//                            div.class("p-2").child(
//                                form.class("needs-validation").novalidate.child(
//
//                                    // Topic
//                                    embed(
//                                        SubtopicPicker(idPrefix: "card-"),
//                                        withPath: \.topics
//                                    ),
//
//                                    renderIf(
//                                        isNotNil: \.taskInfo,
//
//                                        renderIf(
//                                            \.taskInfo?.deletedAt != nil,
//
//                                            div.class("badge badge-danger").child(
//                                                "Inaktiv"
//                                            )
//                                        ).else(
//                                            div.class("badge badge-success").child(
//                                                "Godkjent"
//                                            )
//                                        )
//                                    ),
//
//                                    // Exam Paper
//                                    div.class("form-row").child(
//                                        div.class("form-group col-md-6").child(
//                                            label.for("card-exam-semester").class("col-form-label").child(
//                                                "Eksamensett semester"
//                                            ),
//
//                                            select.id("card-exam-semester").class("select2 form-control select2").dataToggle("select2").dataPlaceholder("Velg ...").required.child(
//                                                renderIf(
//                                                    isNotNil: \Context.taskInfo?.examPaperSemester,
//
//                                                    option.value(variable(\.taskInfo?.examPaperSemester?.rawValue)).selected.child(
//                                                        variable(\.taskInfo?.examPaperSemester?.rawValue)
//                                                    )
//                                                ),
//                                                option.value("").child(
//                                                    "Ikke eksamensoppgave"
//                                                ),
//                                                option.value("fall").child(
//                                                    "Høst"
//                                                ),
//                                                option.value("spring").child(
//                                                    "Vår"
//                                                )
//                                            )
//                                        ),
//
//                                        div.class("form-group col-md-6").child(
//                                            label.for("card-exam-year").class("col-form-label").child(
//                                                "År"
//                                            ),
//                                            input.type("number").class("form-control").id("card-exam-year").placeholder("2019").value(variable(\.taskInfo?.examPaperYear)).required
//                                        )
//                                    ),
//
//                                    // Description
//                                    div.class("form-group").child(
//                                        label.for("card-description").class("col-form-label").child(
//                                            "Oppgavetekst"
//                                        ),
//                                        div.id("card-description").child(
//                                            variable(\.taskInfo?.description, escaping: .unsafeNone)
//                                        )
//                                    ),
//
//                                    // Question
//                                    div.class("form-group").child(
//                                        label.for("card-question").class("col-form-label").child(
//                                            "Spørsmål"
//                                        ),
//                                        textarea.class("form-control").id("card-question").rows(1).placeholder("Noe å svare på her").required.child(
//                                            variable(\.taskInfo?.question)
//                                        ),
//                                        div.class("invalid-feedback").child(
//                                            "Bare lov med store og små bokstaver, tall, mellomrom + (. , : ; !, ?)"
//                                        )
//                                    ),
//
//                                    // Solution
//                                    div.class("form-group").child(
//                                        label.for("card-solution").class("col-form-label").child(
//                                            "Løsning"
//                                        ),
//                                        div.id("card-solution").child(
//                                            variable(\.taskInfo?.solution, escaping: .unsafeNone)
//                                        )
//                                    ),
//
//                                    DismissableError(),
//
//                                    button.type("button").onclick(
//                                        renderIf(isNil: \.taskInfo, "createFlashCard();").else("editFlashCard();")
//                                        ).class("btn btn-success mb-3 mt-3").child(
//                                            i.class("mdi mdi-save"),
//                                            " Lagre"
//                                    )
//                                )
//                            )
//                        )
//                    )
//                ),
//
//                headerLinks: [
//                    link.href("/assets/css/vendor/summernote-bs4.css").rel("stylesheet").type("text/css"),
//                    link.href("https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0/katex.min.css").rel("stylesheet")
//                ],
//
//                scripts: [
//                    script.src("/assets/js/vendor/summernote-bs4.min.js"),
//                    script.src("https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0/katex.min.js"),
//                    script.src("/assets/js/vendor/summernote-math.js"),
//                    script.src("/assets/js/dismissable-error.js"),
//                    script.src("/assets/js/flash-card/json-data.js"),
//
//                    renderIf(
//                        isNil: \Context.taskInfo,
//
//                        script.src("/assets/js/flash-card/create.js")
//                    ).else(
//                        script.src("/assets/js/flash-card/edit.js")
//                    )
//                ]
//            ),
//            withPath: \Context.base)
//    }
//}
