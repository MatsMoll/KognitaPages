//
//  CreateSubtopicTemplate.swift
//  KognitaViews
//
//  Created by Mats Mollestad on 26/08/2019.
//

import HTMLKit
import KognitaCore

extension Subtopic.Create {

    public struct Template : LocalizedTemplate {

        public enum LocalizationKeys : String {
            case empty
        }

        public init() {}

        public static var localePath: KeyPath<Context, String>? = \.locale

        public struct Context {
            let locale = "nb"
            let base: ContentBaseTemplate.Context
            let topics: TopicPicker.Context
            let subject: Subject

            /// The topic to edit
            let subtopicInfo: Subtopic?

            public init(user: User, subject: Subject, topics: [Topic], subtopicInfo: Subtopic? = nil) {
                self.base = .init(user: user, title: "Lag undertema")
                self.subject = subject
                self.subtopicInfo = subtopicInfo
                self.topics = .init(topics: topics, selectedSubtopicId: subtopicInfo?.topicId)
            }
        }

        public func build() -> CompiledTemplate {

            let scripts: [CompiledTemplate] = [
                script.src("/assets/js/vendor/summernote-bs4.min.js"),
                script.src("https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0/katex.min.js"),
                script.src("/assets/js/vendor/summernote-math.js"),
                script.src("/assets/js/dismissable-error.js"),
                script.src("/assets/js/subtopic/json-data.js"),

                renderIf(
                    isNil: \.subtopicInfo,
                    script.src("/assets/js/subtopic/create.js")
                ).else(
                    script.src("/assets/js/subtopic/edit.js"),
                    script.src("/assets/js/subtopic/delete.js")
                )
            ]

            return embed(
                ContentBaseTemplate(
                    body:

                    div.class("card mt-5").child(
                        div.class("modal-header text-white bg-" + variable(\.subject.colorClass.rawValue)).child(
                            h4.class("modal-title").id("create-modal-label").child(
                                variable(\.subject.name),
                                renderIf(isNil: \.subtopicInfo, " | Lag nytt undertema").else(" | Rediger undertema")
                            )
                        ),
                        div.class("modal-body").child(
                            div.class("p-2").child(
                                form.child(

                                    div.class("form-row").child(
                                        embed(
                                            TopicPicker(),
                                            withPath: \.topics
                                        )
                                    ),

                                    div.class("form-row").child(
                                        label.for("subtopic-name").class("col-form-label").child(
                                            "Navn"
                                        ),
                                        input.type("text")
                                            .class("form-control")
                                            .id("subtopic-name")
                                            .placeholder("Sannsynlighet")
                                            .value(variable(\.subtopicInfo?.name))
                                            .required,
                                        small.child(
                                            "Bare lov vanlig bokstaver og mellomrom"
                                        )
                                    ),
                                    div.class("form-row").child(
                                        label.for("subtopic-name").class("col-form-label").child(
                                            "Kapittel"
                                        ),
                                        input.type("number").class("form-control").id("subtopic-chapter").placeholder("1").required.value(variable(\.subtopicInfo?.chapter)),
                                        small.child(
                                            "Kan ikke ha samme verdi som noen andre kapittler"
                                        )
                                    ),

                                    DismissableError(),

                                    // CTA Buttons
                                    renderIf(
                                        isNotNil: \.subtopicInfo,

                                        // Edit & Delete
                                        button.type("button").onclick("editSubtopic(", variable(\.subtopicInfo?.id), ")").class("btn btn-success mb-3 mt-3 mr-2").child(
                                            " Lagre"
                                        ),
                                        button.type("button").onclick("deleteSubtopic(", variable(\.subtopicInfo?.id), ")").class("btn btn-danger mb-3 mt-3").child(
                                            " Slett"
                                        )
                                    ).else(
                                        // Create
                                        button.type("button").onclick("createSubtopic()").class("btn btn-success btn-rounded mb-3 mt-3").child(
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
    }
}

