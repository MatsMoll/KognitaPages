//
//  CreateNumberInputTaskTemplate.swift
//  App
//
//  Created by Mats Mollestad on 23/03/2019.
//

import HTMLKit
import KognitaCore

extension NumberInputTask.Templates {
    public struct Create: TemplateView {

        public struct Context {
            let user: User
            let subject: Subject
            let topics: [Topic.Response]

            // Used to edit a task
            let taskInfo: Task?
            let inputTask: NumberInputTask?

            public init(user: User, subject: Subject, topics: [Topic.Response], content: NumberInputTask.Data? = nil, selectedTopicId: Int? = nil) {
                self.user = user
                self.subject = subject
                self.topics = topics
//                let sortSelectedTopicId = selectedTopicId ?? taskInfo?.subtopicId
//                self.topics = .init(topics: topics, selectedSubtopicId: sortSelectedTopicId)
                self.taskInfo = content?.task
                self.inputTask = content?.input
            }

            public init(user: User, topics: [Topic.Response], preview: TaskPreviewContent, content: NumberInputTask, selectedTopicId: Int? = nil) {
                self.user = user
                self.subject = preview.subject
                self.topics = topics
//                let sortSelectedTopicId = selectedTopicId ?? taskInfo?.subtopicId
//                self.topics = .init(topics: topics, selectedSubtopicId: sortSelectedTopicId)
                self.taskInfo = preview.task
                self.inputTask = content
            }
        }

        public init() {}

        public let context: RootValue<Context> = .root()

        public var body: View {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Lag oppgave", description: "Lag oppgave")),
                content:

                Div {
                    Div {
                        Div {
                            H4 {
                                context.subject.name
                                " | Lag innskrivningsoppgave"
                            }.class("modal-title").id("create-modal-label")
                        }.class("modal-header text-white bg-" + context.subject.colorClass.rawValue)
                        Div {
                            Div {
                                Form {
                                    SubtopicPicker(
                                        idPrefix: "create-input-",
                                        topics: context.topics
                                    )

                                    Div {
                                        Div {
                                            Label {
                                                "Eksamensett semester"
                                            }.for("create-input-exam-semester").class("col-form-label")
                                            Select {
                                                IF(context.value(at: \.taskInfo?.examPaperSemester).isDefined) {
                                                    Option {
                                                        context.value(at: \.taskInfo?.examPaperSemester?.rawValue)
                                                    }
                                                    .value(context.value(at: \.taskInfo?.examPaperSemester?.rawValue))
                                                    .isSelected(true)
                                                }
                                                Option {
                                                    "Ikke eksamensoppgave"
                                                }
                                                .value("")
                                                Option {
                                                    "Høst"
                                                }
                                                .value("fall")
                                                Option {
                                                    "Vår"
                                                }
                                                .value("spring")
                                            }
                                            .id("create-input-exam-semester")
                                            .class("select2 form-control select2")
                                            .data(for: "toggle", value: "select2")
                                            .data(for: "placeholder", value: "Velg ...")
//                                            .required()
                                        }.class("form-group col-md-6")

                                        Div {
                                            Label {
                                                "År"
                                            }
                                            .for("create-input-exam-year")
                                            .class("col-form-label")
                                            Input()
                                                .type(.number)
                                                .class("form-control")
                                                .id("create-input-exam-year")
                                                .placeholder("2019")
                                                .value(context.value(at: \.taskInfo?.examPaperYear))
                                                .required()
                                        }
                                        .class("form-group col-md-6")
                                    }
                                    .class("form-row")
                                    Div {
                                        Input()
                                            .type(.checkbox)
                                            .class("custom-control-input")
                                            .id("create-input-examinable")
                                            .isChecked(true)
                                        Label {
                                            "Bruk på prøver"
                                        }.for("create-input-examinable").class("custom-control-label")
                                    }.class("custom-control custom-checkbox mt-3")
                                    Div {
                                        Label {
                                            "Oppgavetekst"
                                        }.for("create-input-description").class("col-form-label")
                                        Div {
                                            context.value(at: \.taskInfo?.description).escaping(.unsafeNone)
                                        }.id("create-input-description")
                                    }.class("form-group")
                                    Div {
                                        Label {
                                            "Spørsmål"
                                        }.for("create-input-question").class("col-form-label")
                                        TextArea {
                                            context.value(at: \.taskInfo?.question)
                                        }
                                        .class("form-control")
                                        .id("create-input-question")
//                                        .rows(1)
                                        .placeholder("Noe å svare på her")
                                        .required()
                                        Div {
                                            "Bare lov med store og små bokstaver, tall, mellomrom + (. , : ; !, ?)"
                                        }.class("invalid-feedback")
                                    }.class("form-group")

                                    Div {
                                        Div {
                                            Label {
                                                "Riktig svar"
                                            }.for("create-input-answer").class("col-form-label")
                                            Input().type("number").class("form-control").id("create-input-answer").placeholder("50").value(context.value(at: \.inputTask?.correctAnswer)).required()
                                            Small {
                                                "Skal du skrive desimaltall må det brukes "
                                                " eks. 2,5. Punktum og mellomrom vil bli ignorert. Altså 10.000 og 10 000 vil bli tolka som 10000"
                                            }
                                        }.class("form-group col-md-9")
                                        Div {
                                            Label {
                                                "Enhet"
                                            }.for("create-input-answer").class("col-form-label")
                                            TextArea {
                                                context.value(at: \.inputTask?.unit)
                                            }
                                            .class("form-control")
                                            .id("create-input-unit")
//                                            .rows(1)
                                            .placeholder("cm")
                                        }.class("form-group col-md-3")
                                    }.class("form-row")


                                    DismissableError()

                                    Button {
                                        Italic().class("mdi mdi-save")
                                        " Lagre"
                                    }
                                    .type(.button)
                                    .on(click: IF(context.taskInfo.isDefined) { "editInputChoise();" }.else { "createInputChoise();" })
                                    .class("btn btn-success mb-3 mt-3")
                                }
                                .class("needs-validation")
//                                .novalidate()
                            }
                            .class("p-2")
                        }
                        .class("modal-body")
                    }
                    .class("card")
                }
                .class("pt-5"),

                headerLinks: [
                    Link().href("/assets/css/vendor/summernote-bs4.css").relationship("stylesheet").type("text/css"),
                    Link().href("https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0/katex.min.css").relationship("stylesheet")
                ],

                scripts: [
                    Script().source("/assets/js/vendor/summernote-bs4.min.js"),
                    Script().source("https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0/katex.min.js"),
                    Script().source("/assets/js/vendor/summernote-math.js"),
                    Script().source("/assets/js/dismissable-error.js"),
                    Script().source("/assets/js/input/json-data.js"),

                    IF(context.taskInfo.isDefined) {
                        Script().source("/assets/js/input/edit.js")
                    }.else {
                        Script().source("/assets/js/input/create.js")
                    }
                ]
            )
        }
    }
}

//public class CreateNumberInputTaskTemplate: LocalizedTemplate {
//
//    public init() {}
//
//    public static var localePath: KeyPath<CreateNumberInputTaskTemplate.Context, String>? = \.locale
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
//        let inputTask: NumberInputTask?
//
//        public init(user: User, subject: Subject, topics: [Topic.Response], content: NumberInputTask.Data? = nil, selectedTopicId: Int? = nil) {
//            self.base = .init(user: user, title: "Lag Oppgave")
//            self.subject = subject
//            let sortSelectedTopicId = selectedTopicId ?? content?.task.editedTaskID
//            self.topics = .init(topics: topics, selectedSubtopicId: sortSelectedTopicId)
//            self.taskInfo = content?.task
//            self.inputTask = content?.input
//        }
//
//        public init(user: User, topics: [Topic.Response], preview: TaskPreviewContent, content: NumberInputTask, selectedTopicId: Int? = nil) {
//            self.base = .init(user: user, title: "Lag Oppgave")
//            self.subject = preview.subject
//            let sortSelectedTopicId = preview.task.subtopicId
//            self.topics = .init(topics: topics, selectedSubtopicId: sortSelectedTopicId)
//            self.taskInfo = preview.task
//            self.inputTask = content
//        }
//    }
//
//    public func build() -> CompiledTemplate {
//        return embed(
//            ContentBaseTemplate(
//                body:
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
//                                        SubtopicPicker(idPrefix: "create-input-"),
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
//                                            label.for("create-input-exam-semester").class("col-form-label").child(
//                                                "Eksamensett semester"
//                                            ),
//
//                                            select.id("create-input-exam-semester").class("select2 form-control select2").dataToggle("select2").dataPlaceholder("Velg ...").required.child(
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
//                                            label.for("create-input-exam-year").class("col-form-label").child(
//                                                "År"
//                                            ),
//                                            input.type("number").class("form-control").id("create-input-exam-year").placeholder("2019").value(variable(\.taskInfo?.examPaperYear)).required
//                                        )
//                                    ),
//
//                                    // Is Examinable
//                                    div.class("custom-control custom-checkbox mt-3").child(
//                                        input.type("checkbox").class("custom-control-input").id("create-input-examinable").checked,
//                                        label.for("create-input-examinable").class("custom-control-label").child(
//                                            "Bruk på prøver"
//                                        )
//                                    ),
//
//                                    // Description
//                                    div.class("form-group").child(
//                                        label.for("create-input-description").class("col-form-label").child(
//                                            "Oppgavetekst"
//                                        ),
//                                        div.id("create-input-description").child(
//                                            variable(\.taskInfo?.description, escaping: .unsafeNone)
//                                        )
//                                    ),
//
//                                    // Question
//                                    div.class("form-group").child(
//                                        label.for("create-input-question").class("col-form-label").child(
//                                            "Spørsmål"
//                                        ),
//                                        textarea.class("form-control").id("create-input-question").rows(1).placeholder("Noe å svare på her").required.child(
//                                            variable(\.taskInfo?.question)
//                                        ),
//                                        div.class("invalid-feedback").child(
//                                            "Bare lov med store og små bokstaver, tall, mellomrom + (. , : ; !, ?)"
//                                        )
//                                    ),
//
//                                    div.class("form-row").child(
//
//                                        // Correct Answer
//                                        div.class("form-group col-md-9").child(
//                                            label.for("create-input-answer").class("col-form-label").child(
//                                                "Riktig svar"
//                                            ),
//                                            input.type("number").class("form-control").id("create-input-answer").placeholder("50").value(variable(\.inputTask?.correctAnswer)).required,
//
//                                            small.child(
//                                                "Skal du skrive desimaltall må det brukes \",\" eks. 2,5. Punktum og mellomrom vil bli ignorert. Altså 10.000 og 10 000 vil bli tolka som 10000"
//                                            )
//                                        ),
//
//                                        // Unit
//                                        div.class("form-group col-md-3").child(
//                                            label.for("create-input-answer").class("col-form-label").child(
//                                                "Enhet"
//                                            ),
//                                            textarea.class("form-control").id("create-input-unit").rows(1).placeholder("cm").child(
//                                                variable(\.inputTask?.unit)
//                                            )
//                                        )
//                                    ),
//
//                                    // Solution
//                                    div.class("form-group").child(
//                                        label.for("create-input-solution").class("col-form-label").child(
//                                            "Løsning"
//                                        ),
//                                        div.id("create-input-solution").child(
//                                            variable(\.taskInfo?.solution, escaping: .unsafeNone)
//                                        )
//                                    ),
//
//                                    DismissableError(),
//
//                                    button.type("button").onclick(
//                                        renderIf(isNil: \Context.taskInfo, "createInputChoise();").else("editInputChoise();")
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
//                    script.src("/assets/js/input/json-data.js"),
//
//                    renderIf(
//                        isNil: \Context.taskInfo,
//
//                        script.src("/assets/js/input/create.js")
//                    ).else(
//                        script.src("/assets/js/input/edit.js")
//                    )
//                ]
//            ),
//            withPath: \Context.base)
//    }
//
//    // MARK: - Subviews
//
//    struct TopicSelect: ContextualTemplate {
//
//        struct Context {
//            let topicResponse: Topic.Response
//            let isSelected: Bool
//        }
//
//        func build() -> CompiledTemplate {
//            return option.if(\.isSelected, add: .selected).value(variable(\.topicResponse.topic.id)).child(
//                variable(\.topicResponse.topic.name)
//            )
//        }
//    }
//}
