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
    public struct Create: HTMLTemplate {

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

        public let context: TemplateValue<Context> = .root()

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
                            CreateForm(
                                topics: context.topics,
                                selectedTopicId: context.selectedTopicId,
                                subtopicInfo: context.subtopicInfo
                            )
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

    struct CreateForm: HTMLComponent {

        let topics: TemplateValue<[Topic]>
        let selectedTopicId: TemplateValue<Topic.ID?>
        let subtopicInfo: TemplateValue<Subtopic?>

        var body: HTML {
            Form {
                FormRow {
                    TopicPicker(
                        topics: topics,
                        selectedTopicId: selectedTopicId
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
                        .value(Unwrap(subtopicInfo) { $0.name })
                        .required()
                    Small {
                        "Kun tillatt med bokstaver, tall og mellomrom"
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
                        .value(Unwrap(subtopicInfo) { $0.chapter })
                        .required()
                    Small {
                        "Kan ikke ha samme verdi som andre kapitler"
                    }
                }

                DismissableError()

                Unwrap(subtopicInfo) { subtopic in
                    Button { " Lagre" }
                        .type("button")
                        .on(click: "editSubtopic(" + subtopic.id + ")")
                        .class("btn btn-success mb-3 mt-3 mr-2")
                    Button { " Slett" }
                        .type("button")
                        .on(click: "deleteSubtopic(" + subtopic.id + ")")
                        .class("btn btn-danger mb-3 mt-3")
                }.else {
                    Button { " Lagre" }
                        .type("button")
                        .on(click: "createSubtopic()")
                        .class("btn btn-success btn-rounded mb-3 mt-3")
                }

            }
        }
    }
}
