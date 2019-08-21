//
//  CreateFlashCardTaskTemplate.swift
//  App
//
//  Created by Mats Mollestad on 31/03/2019.
//

import HTMLKit
import KognitaCore

public class CreateFlashCardTaskTemplate: LocalizedTemplate {

    public init() {}

    public static var localePath: KeyPath<CreateFlashCardTaskTemplate.Context, String>? = \.locale

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

        public init(user: User, subject: Subject, topics: [Topic], content: Task? = nil, selectedTopicId: Int? = nil) {
            self.base = .init(user: user, title: "Lag Oppgave")
            self.subject = subject
            let sortSelectedTopicId = selectedTopicId ?? content?.topicId
            self.topics = topics.map { .init(topic: $0, isSelected: sortSelectedTopicId == $0.id) }.sorted(by: { (first, _) in first.isSelected })
            self.taskInfo = content
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
                                label.for("card-topic-id").class("col-form-label").child(
                                    "Tema"
                                ),
                                select.id("card-topic-id").class("select2 form-control select2").dataToggle("select2").dataPlaceholder("Velg ...").required.child(
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

                                // Description
                                div.class("form-group").child(
                                    label.for("card-description").class("col-form-label").child(
                                        "Oppgavetekst"
                                    ),
                                    div.id("card-description").child(
                                        variable(\.taskInfo?.description, escaping: .unsafeNone)
                                    )
                                ),

                                // Question
                                div.class("form-group").child(
                                    label.for("card-question").class("col-form-label").child(
                                        "Spørsmål"
                                    ),
                                    textarea.class("form-control").id("card-question").rows(1).placeholder("Noe å svare på her").required.child(
                                        variable(\.taskInfo?.question)
                                    ),
                                    div.class("invalid-feedback").child(
                                        "Bare lov med store og små bokstaver, tall, mellomrom + (. , : ; !, ?)"
                                    )
                                ),

                                // Solution
                                div.class("form-group").child(
                                    label.for("card-solution").class("col-form-label").child(
                                        "Løsning"
                                    ),
                                    div.id("card-solution").child(
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
//                                        label.for("card-difficulty").class("col-form-label").child(
//                                            "Vansklighet"
//                                        ),
//                                        input.type("number").class("form-control").id("card-difficulty").placeholder("50").required.value(variable(\.taskInfo?.difficulty)),
//                                        small.child(
//                                            "Verdi fra 1-100, hvor 100 er det vanskligste (Kan ses på som prosentvis andel som ",
//                                            i.child("ikke"),
//                                            " klarer oppgaven)"
//                                        )
//                                    ),
//
//                                    // Estimate time
//                                    div.class("form-group col-md-6").child(
//                                        label.for("card-estimated-time").class("col-form-label").child(
//                                            "Estimert tid"
//                                        ),
//                                        input.type("number").class("form-control").id("card-estimated-time").placeholder("60").required.value(variable(\.taskInfo?.estimatedTime)),
//                                        small.child(
//                                            "Verdi i sekunder"
//                                        )
//                                    )
//                                ),

                                button.type("button").onclick(
                                    renderIf(isNil: \.taskInfo, "createFlashCard();").else("editFlashCard();")
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

                        script.src("/assets/js/flash-card/create.js")
                    ).else(
                        script.src("/assets/js/flash-card/edit.js")
                    )
                ]
            ),
            withPath: \Context.base)
    }


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
