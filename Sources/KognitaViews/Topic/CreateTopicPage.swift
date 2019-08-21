//
//  CreateTopicPage.swift
//  App
//
//  Created by Mats Mollestad on 27/02/2019.
//

import HTMLKit
import KognitaCore

public struct CreateTopicPage: LocalizedTemplate {

    public init() {}

    public static var localePath: KeyPath<CreateTopicPage.Context, String>? = \.locale

    public enum LocalizationKeys: String {
        case none
    }

    public struct Context {
        let locale = "nb"
        let base: ContentBaseTemplate.Context
//        let topics: [PreTopicOption.Context]
        let subject: Subject

        /// The topic to edit
        let topicInfo: Topic?

        public init(user: User, subject: Subject, topicInfo: Topic? = nil) {
            self.base = .init(user: user, title: "Lag temaer")
            self.subject = subject
//            self.topics = topics.map { .init(topic: $0, isSelected: false) }
            self.topicInfo = topicInfo
        }
    }

    public func build() -> CompiledTemplate {

        let scripts: [CompiledTemplate] = [
            script.src("/assets/js/vendor/summernote-bs4.min.js"),
            script.src("https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0/katex.min.js"),
            script.src("/assets/js/vendor/summernote-math.js"),

            renderIf(
                isNil: \.topicInfo,
                script.src("/assets/js/topic/create.js")
            ).else(
                script.src("/assets/js/topic/edit.js"),
                script.src("/assets/js/topic/delete.js")
            )
        ]

        return embed(
            ContentBaseTemplate(
                body:

                div.class("card mt-5").child(
                    div.class("modal-header text-white bg-" + variable(\.subject.colorClass.rawValue)).child(
                        h4.class("modal-title").id("create-modal-label").child(
                            variable(\.subject.name),
                            renderIf(isNil: \.topicInfo, " | Lag nytt tema").else(" | Rediger tema")
                        )
                    ),
                    div.class("modal-body").child(
                        div.class("p-2").child(
                            form.child(
                                div.class("form-row").child(
                                    label.for("create-topic-name").class("col-form-label").child(
                                        "Navn"
                                    ),
                                    input.type("text").class("form-control").id("create-topic-name").placeholder("Sannsynlighet").required.value(variable(\.topicInfo?.name)),
                                    small.child(
                                        "Bare lov vanlig bokstaver og mellomrom"
                                    )
                                ),
                                div.class("form-group").child(
                                    label.for("create-topic-name").class("col-form-label").child(
                                        "Kapittel"
                                    ),
                                    input.type("number").class("form-control").id("create-topic-chapter").placeholder("1").required.value(variable(\.topicInfo?.chapter)),
                                    small.child(
                                        "Kan ikke ha samme verdi som noen andre kapittler"
                                    )
                                ),
                                div.class("form-group").child(
                                    label.for("create-topic-description").class("col-form-label").child(
                                        "Beskrivelse"
                                    ),
                                    div.id("create-topic-description").child(
                                        variable(\.topicInfo?.description, escaping: .unsafeNone)
                                    )
                                ),
//                                label.for("create-topic-preTopicId").class("col-form-label").child(
//                                    "Baseres på"
//                                ),
//                                select.id("create-topic-preTopicId").class("select2 form-control select2").dataToggle("select2").dataPlaceholder("Velg ...").child(
//                                    option.selected.child(
//                                        "Ingen"
//                                    ),
//                                    forEach(in:     \.topics,
//                                            render: PreTopicOption()
//                                    )
//                                ),

                                // CTA Buttons
                                renderIf(
                                    isNotNil: \.topicInfo,

                                    // Edit & Delete
                                    button.type("button").onclick("editTopic(", variable(\.topicInfo?.id), ")").class("btn btn-success mb-3 mt-3 mr-2").child(
                                        " Lagre"
                                    ),
                                    button.type("button").onclick("deleteTopic(", variable(\.topicInfo?.id), ")").class("btn btn-danger mb-3 mt-3").child(
                                        " Slett"
                                    )
                                ).else(
                                    // Create
                                    button.type("button").onclick("createTopic()").class("btn btn-success btn-rounded mb-3 mt-3").child(
                                        " Lagre"
                                    )
                                )
                            )
                        )
                    )
                ),

                headerLinks: [
                    link.href("/assets/css/vendor/summernote-bs4.css").rel("stylesheet").type("text/css"),
                    link.href("https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0/katex.min.css").rel("stylesheet")
                ],

                scripts: scripts
            ),
            withPath: \.base)
    }


    // MARK: - Subviews
    
//    struct PreTopicOption: ContextualTemplate {
//        struct Context {
//            let topic: Topic
//            let isSelected: Bool
//        }
//
//        func build() -> CompiledTemplate {
//            return option.value(variable(\.topic.id))
//                .if(\.isSelected, add: .selected).child(
//                    variable(\.topic.name)
//            )
//        }
//    }
}
