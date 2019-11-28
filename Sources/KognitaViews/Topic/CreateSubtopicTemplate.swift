//
//  CreateSubtopicTemplate.swift
//  KognitaViews
//
//  Created by Mats Mollestad on 26/08/2019.
//

import BootstrapKit
import KognitaCore

extension Subtopic {
    public struct Templates {}
}

extension Subtopic.Templates {
    public struct Create: TemplateView {

        public struct Context {
            let user: User
//            let topics: TopicPicker.Context
            let topics: [Topic]
            let selectedTopicId: Topic.ID?
            let subject: Subject

            /// The topic to edit
            let subtopicInfo: Subtopic?

            public init(user: User, subject: Subject, topics: [Topic], subtopicInfo: Subtopic? = nil) {
                self.user = user
                self.subject = subject
                self.subtopicInfo = subtopicInfo
                self.topics = topics
                self.selectedTopicId = subtopicInfo?.topicId
//                self.topics = .init(topics: topics, selectedSubtopicId: subtopicInfo?.topicId)
            }
        }

        public init() {}

        public let context: RootValue<Context> = .root()

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Lag undertema", description: "Lag undertema"))
            ) {
                Div {
                    Div {
                        H4 {
                            context.subject.name
                            IF(context.subtopicInfo.isDefined) {
                                " | Lag nytt undertema"
                            }.else {
                                " | Rediger undertema"
                            }
                        }
                        .class("modal-title")
                        .id("create-modal-label")
                    }
                    .class("modal-header text-white bg-" + context.subject.colorClass.rawValue)

                    Div {
                        Div {
                            Form {
                                FormRow {
                                    TopicPicker(
                                        topics: context.topics,
                                        selectedTopicId: context.selectedTopicId
                                    )
                                }

                                FormRow {
                                    Label {
                                        "Navn"
                                    }.for("subtopic-name").class("col-form-label")
                                    Input()
                                        .type("text")
                                        .class("form-control")
                                        .id("subtopic-name")
                                        .placeholder("Sannsynlighet")
                                        .value(context.value(at: \.subtopicInfo?.name))
                                        .required()
                                    Small {
                                        "Bare lov vanlig bokstaver og mellomrom"
                                    }
                                }
                                FormRow {
                                    Label {
                                        "Kapittel"
                                    }.for("subtopic-name").class("col-form-label")
                                    Input()
                                        .type("number")
                                        .class("form-control")
                                        .id("subtopic-chapter")
                                        .placeholder("1")
                                        .value(context.value(at: \.subtopicInfo?.chapter))
                                        .required()
                                    Small {
                                        "Kan ikke ha samme verdi som noen andre kapittler"
                                    }
                                }

                                DismissableError()

                                IF(context.subtopicInfo.isDefined) {
                                    Button { " Lagre" }
                                        .type("button")
                                        .on(click: "editSubtopic(" + context.subtopicInfo.unsafelyUnwrapped.id + ")")
                                        .class("btn btn-success mb-3 mt-3 mr-2")
                                    Button { " Slett" }
                                        .type("button")
                                        .on(click: "deleteSubtopic(" + context.subtopicInfo.unsafelyUnwrapped.id + ")")
                                        .class("btn btn-danger mb-3 mt-3")
                                }.else {
                                    Button { " Lagre" }
                                        .type("button")
                                        .on(click: "createSubtopic()")
                                        .class("btn btn-success btn-rounded mb-3 mt-3")
                                }

                            }
                        }
                        .class("p-2")
                    }
                    .class("modal-body")
                }
                .class("card mt-5")
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
                    Script().source("/assets/js/subtopic/json-data.js")
                    IF(context.subtopicInfo.isDefined) {
                        Script().source("/assets/js/subtopic/edit.js")
                        Script().source("/assets/js/subtopic/delete.js")
                    }.else {
                        Script().source("/assets/js/subtopic/create.js")
                    }
            }
        }
    }
}

//extension Subtopic.Create {
//
//    public struct Template : LocalizedTemplate {
//
//        public enum LocalizationKeys : String {
//            case empty
//        }
//
//        public init() {}
//
//        public static var localePath: KeyPath<Context, String>? = \.locale
//
//        public struct Context {
//            let locale = "nb"
//            let base: ContentBaseTemplate.Context
//            let topics: TopicPicker.Context
//            let subject: Subject
//
//            /// The topic to edit
//            let subtopicInfo: Subtopic?
//
//            public init(user: User, subject: Subject, topics: [Topic], subtopicInfo: Subtopic? = nil) {
//                self.base = .init(user: user, title: "Lag undertema")
//                self.subject = subject
//                self.subtopicInfo = subtopicInfo
//                self.topics = .init(topics: topics, selectedSubtopicId: subtopicInfo?.topicId)
//            }
//        }
//
//        public func build() -> CompiledTemplate {
//
//            let scripts: [CompiledTemplate] = [
//                script.src("/assets/js/vendor/summernote-bs4.min.js"),
//                script.src("https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0/katex.min.js"),
//                script.src("/assets/js/vendor/summernote-math.js"),
//                script.src("/assets/js/dismissable-error.js"),
//                script.src("/assets/js/subtopic/json-data.js"),
//
//                renderIf(
//                    isNil: \.subtopicInfo,
//                    script.src("/assets/js/subtopic/create.js")
//                ).else(
//                    script.src("/assets/js/subtopic/edit.js"),
//                    script.src("/assets/js/subtopic/delete.js")
//                )
//            ]
//
//            return embed(
//                ContentBaseTemplate(
//                    body:
//
//                    div.class("card mt-5").child(
//                        div.class("modal-header text-white bg-" + variable(\.subject.colorClass.rawValue)).child(
//                            h4.class("modal-title").id("create-modal-label").child(
//                                variable(\.subject.name),
//                                renderIf(isNil: \.subtopicInfo, " | Lag nytt undertema").else(" | Rediger undertema")
//                            )
//                        ),
//                        div.class("modal-body").child(
//                            div.class("p-2").child(
//                                form.child(
//
//                                    div.class("form-row").child(
//                                        embed(
//                                            TopicPicker(),
//                                            withPath: \.topics
//                                        )
//                                    ),
//
//                                    div.class("form-row").child(
//                                        label.for("subtopic-name").class("col-form-label").child(
//                                            "Navn"
//                                        ),
//                                        input.type("text")
//                                            .class("form-control")
//                                            .id("subtopic-name")
//                                            .placeholder("Sannsynlighet")
//                                            .value(variable(\.subtopicInfo?.name))
//                                            .required,
//                                        small.child(
//                                            "Bare lov vanlig bokstaver og mellomrom"
//                                        )
//                                    ),
//                                    div.class("form-row").child(
//                                        label.for("subtopic-name").class("col-form-label").child(
//                                            "Kapittel"
//                                        ),
//                                        input.type("number").class("form-control").id("subtopic-chapter").placeholder("1").required.value(variable(\.subtopicInfo?.chapter)),
//                                        small.child(
//                                            "Kan ikke ha samme verdi som noen andre kapittler"
//                                        )
//                                    ),
//
//                                    DismissableError(),
//
//                                    // CTA Buttons
//                                    renderIf(
//                                        isNotNil: \.subtopicInfo,
//
//                                        // Edit & Delete
//                                        button.type("button").onclick("editSubtopic(", variable(\.subtopicInfo?.id), ")").class("btn btn-success mb-3 mt-3 mr-2").child(
//                                            " Lagre"
//                                        ),
//                                        button.type("button").onclick("deleteSubtopic(", variable(\.subtopicInfo?.id), ")").class("btn btn-danger mb-3 mt-3").child(
//                                            " Slett"
//                                        )
//                                    ).else(
//                                        // Create
//                                        button.type("button").onclick("createSubtopic()").class("btn btn-success btn-rounded mb-3 mt-3").child(
//                                            " Lagre"
//                                        )
//                                    )
//                                )
//                            )
//                        )
//                    ),
//
//                    headerLinks: [
//                        link.href("/assets/css/vendor/summernote-bs4.css").rel("stylesheet").type("text/css"),
//                        link.href("https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0/katex.min.css").rel("stylesheet")
//                    ],
//
//                    scripts: scripts
//                ),
//                withPath: \.base)
//        }
//    }
//}

