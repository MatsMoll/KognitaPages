//
//  CreateNumberInputTaskTemplate.swift
//  App
//
//  Created by Mats Mollestad on 23/03/2019.
//

import HTMLKit
import KognitaCore


public class CreateNumberInputTaskTemplate: LocalizedTemplate {

    public init() {}

    public static var localePath: KeyPath<CreateNumberInputTaskTemplate.Context, String>? = \.locale

    public enum LocalizationKeys: String {
        case none
    }

    public struct Context {
        let locale = "nb"
        let base: ContentBaseTemplate.Context
        let subject: Subject
        let topics: [TopicSelect.Context]

        // Used to edit a task
        let taskInfo: Task?
        let inputTask: NumberInputTask?

        public init(user: User, subject: Subject, topics: [Topic], content: NumberInputTaskContent? = nil, selectedTopicId: Int? = nil) {
            self.base = .init(user: user, title: "Lag Oppgave")
            self.subject = subject
            let sortSelectedTopicId = selectedTopicId ?? content?.task.topicId
            self.topics = topics.map { .init(topic: $0, isSelected: sortSelectedTopicId == $0.id) }.sorted(by: { (first, _) in first.isSelected })
            self.taskInfo = content?.task
            self.inputTask = content?.input
        }

        public init(user: User, topics: [Topic], preview: TaskPreviewContent, content: NumberInputTask, selectedTopicId: Int? = nil) {
            self.base = .init(user: user, title: "Lag Oppgave")
            self.subject = preview.subject
            let sortSelectedTopicId = preview.task.topicId
            self.topics = topics.map { .init(topic: $0, isSelected: sortSelectedTopicId == $0.id) }.sorted(by: { (first, _) in first.isSelected })
            self.taskInfo = preview.task
            self.inputTask = content
        }
    }

    public func build() -> CompiledTemplate {
        return embed(
            ContentBaseTemplate(
                body:
                div.class("card mt-5").child(
                    div.class("modal-header text-white bg-" + variable(\.subject.colorClass.rawValue)).child(
                        h4.class("modal-title").id("create-modal-label").child(
                            variable(\.subject.name), " | Lag innskrivningsoppgave"
                        )
                    ),
                    div.class("modal-body").child(
                        div.class("p-2").child(
                            form.class("needs-validation").novalidate.child(

                                // Topic
                                label.for("create-input-topic-id").class("col-form-label").child(
                                    "Tema"
                                ),
                                select.id("create-input-topic-id").class("select2 form-control select2").dataToggle("select2").dataPlaceholder("Velg ...").required.child(

                                    option.child(
                                        "Velg ..."
                                    ),
                                    forEach(
                                        in:     \.topics,
                                        render: TopicSelect()
                                    )
                                ),

                                renderIf(
                                    isNotNil: \.taskInfo,

                                    renderIf(
                                        \.taskInfo?.deletedAt != nil,

                                        div.class("badge badge-danger").child(
                                            "Inaktiv"
                                        )
                                    ).else(
                                        div.class("badge badge-success").child(
                                            "Godkjent"
                                        )
                                    )
                                ),

                                // Exam Paper
                                div.class("form-row").child(
                                    div.class("form-group col-md-6").child(
                                        label.for("create-input-exam-semester").class("col-form-label").child(
                                            "Eksamensett semester"
                                        ),

                                        select.id("create-input-exam-semester").class("select2 form-control select2").dataToggle("select2").dataPlaceholder("Velg ...").required.child(
                                            renderIf(
                                                isNotNil: \Context.taskInfo?.examPaperSemester,

                                                option.value(variable(\.taskInfo?.examPaperSemester?.rawValue)).selected.child(
                                                    variable(\.taskInfo?.examPaperSemester?.rawValue)
                                                )
                                            ),
                                            option.value("").child(
                                                "Ikke eksamensoppgave"
                                            ),
                                            option.value("fall").child(
                                                "Høst"
                                            ),
                                            option.value("spring").child(
                                                "Vår"
                                            )
                                        )
                                    ),

                                    div.class("form-group col-md-6").child(
                                        label.for("create-input-exam-year").class("col-form-label").child(
                                            "År"
                                        ),
                                        input.type("number").class("form-control").id("create-input-exam-year").placeholder("2019").value(variable(\.taskInfo?.examPaperYear)).required
                                    )
                                ),

                                // Is Examinable
                                div.class("custom-control custom-checkbox mt-3").child(
                                    input.type("checkbox").class("custom-control-input").id("create-input-examinable").checked,
                                    label.for("create-input-examinable").class("custom-control-label").child(
                                        "Bruk på prøver"
                                    )
                                ),

                                // Description
                                div.class("form-group").child(
                                    label.for("create-input-description").class("col-form-label").child(
                                        "Oppgavetekst"
                                    ),
                                    div.id("create-input-description").child(
                                        variable(\.taskInfo?.description, escaping: .unsafeNone)
                                    )
                                ),

                                // Question
                                div.class("form-group").child(
                                    label.for("create-input-question").class("col-form-label").child(
                                        "Spørsmål"
                                    ),
                                    textarea.class("form-control").id("create-input-question").rows(1).placeholder("Noe å svare på her").required.child(
                                        variable(\.taskInfo?.question)
                                    ),
                                    div.class("invalid-feedback").child(
                                        "Bare lov med store og små bokstaver, tall, mellomrom + (. , : ; !, ?)"
                                    )
                                ),

                                div.class("form-row").child(

                                    // Correct Answer
                                    div.class("form-group col-md-9").child(
                                        label.for("create-input-answer").class("col-form-label").child(
                                            "Riktig svar"
                                        ),
                                        input.type("number").class("form-control").id("create-input-answer").placeholder("50").value(variable(\.inputTask?.correctAnswer)).required,

                                        small.child(
                                            "Skal du skrive desimaltall må det brukes \",\" eks. 2,5. Punktum og mellomrom vil bli ignorert. Altså 10.000 og 10 000 vil bli tolka som 10000"
                                        )
                                    ),

                                    // Unit
                                    div.class("form-group col-md-3").child(
                                        label.for("create-input-answer").class("col-form-label").child(
                                            "Enhet"
                                        ),
                                        textarea.class("form-control").id("create-input-unit").rows(1).placeholder("cm").child(
                                            variable(\.inputTask?.unit)
                                        )
                                    )
                                ),

                                // Solution
                                div.class("form-group").child(
                                    label.for("create-input-solution").class("col-form-label").child(
                                        "Løsning"
                                    ),
                                    div.id("create-input-solution").child(
                                        variable(\.taskInfo?.solution, escaping: .unsafeNone)
                                    )
                                ),

//                                div.class("form-row").child(
//
//                                    p.child(
//                                        "Disse skal bli automatisk basert på bruker resultater, men greit med et estemat i starten"
//                                    ),
//
//                                    // Difficulty
//                                    div.class("form-group col-md-6").child(
//                                        label.for("create-input-difficulty").class("col-form-label").child(
//                                            "Vansklighet"
//                                        ),
//                                        input.type("number").class("form-control").id("create-input-difficulty").placeholder("50").required.value(variable(\.taskInfo?.difficulty)),
//                                        small.child(
//                                            "Verdi fra 1-100, hvor 100 er det vanskligste (Kan ses på som prosentvis andel som ",
//                                            i.child("ikke"),
//                                            " klarer oppgaven)"
//                                        )
//                                    ),
//
//                                    // Estimate time
//                                    div.class("form-group col-md-6").child(
//                                        label.for("create-input-estimated-time").class("col-form-label").child(
//                                            "Estimert tid"
//                                        ),
//                                        input.type("number").class("form-control").id("create-input-estimated-time").placeholder("60").required.value(variable(\.taskInfo?.estimatedTime)),
//                                        small.child(
//                                            "Verdi i sekunder"
//                                        )
//                                    )
//                                ),

                                button.type("button").onclick(
                                    renderIf(isNil: \Context.taskInfo, "createInputChoise();").else("editInputChoise();")
                                    ).class("btn btn-success mb-3 mt-3").child(
                                        i.class("mdi mdi-save"),
                                        " Lagre"
                                )
                            )
                        )
                    )
                ),

                headerLinks: [
                    link.href("/assets/css/vendor/summernote-bs4.css").rel("stylesheet").type("text/css"),
                    link.href("https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0/katex.min.css").rel("stylesheet")
                ],

                scripts: [
                    script.src("/assets/js/vendor/summernote-bs4.min.js"),
                    script.src("https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0/katex.min.js"),
                    script.src("/assets/js/vendor/summernote-math.js"),

                    renderIf(
                        isNil: \Context.taskInfo,

                        script.src("/assets/js/input/create.js")
                    ).else(
                        script.src("/assets/js/input/edit.js")
                    )
                ]
            ),
            withPath: \Context.base)
    }

    // MARK: - Subviews

    struct TopicSelect: ContextualTemplate {

        struct Context {
            let topic: Topic
            let isSelected: Bool
        }

        func build() -> CompiledTemplate {
            return option.if(\.isSelected, add: .selected).value(variable(\.topic.id)).child(
                variable(\.topic.name)
            )
        }
    }
}
