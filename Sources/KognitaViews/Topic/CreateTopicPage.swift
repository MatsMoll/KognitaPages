//
//  CreateTopicPage.swift
//  App
//
//  Created by Mats Mollestad on 27/02/2019.
//

import BootstrapKit
import KognitaCore

extension Topic {
    public struct Templates {}
}

extension Topic.Templates {
    public struct Create: HTMLTemplate {

        public struct Context {
            let user: User
            let subject: Subject

            /// The topic to edit
            let topicInfo: Topic?

            public init(user: User, subject: Subject, topicInfo: Topic? = nil) {
                self.user = user
                self.subject = subject
    //            self.topics = topics.map { .init(topic: $0, isSelected: false) }
                self.topicInfo = topicInfo
            }
        }

        public init() {}

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Lag temaer", description: "Lag temaer"))
            ) {
                Div {
                    DismissableError()
                    Div {
                        Div {
                            Form {
                                Div {
                                    Label {
                                        "Navn"
                                    }.for("create-topic-name").class("col-form-label")
                                    Input()
                                        .type("text")
                                        .class("form-control")
                                        .id("create-topic-name")
                                        .placeholder("Sannsynlighet")
                                        .required()
                                        .value(Unwrap(context.topicInfo) { $0.name })
                                    Small {
                                        "Kun tillatt med bokstaver, tall og mellomrom"
                                    }
                                }.class("form-row")
                                Div {
                                    Label {
                                        "Kapittel"
                                    }.for("create-topic-name").class("col-form-label")
                                    Input()
                                        .type(.number)
                                        .class("form-control")
                                        .id("create-topic-chapter")
                                        .placeholder("1")
                                        .required()
                                        .value(Unwrap(context.topicInfo) { $0.chapter })
                                    Small {
                                        "Kan ikke ha samme verdi som noen andre kapitler"
                                    }
                                }.class("form-group")

                                ActionButtons(topic: context.topicInfo)
                            }
                        }.class("p-2")
                    }.class("modal-body")
                }.class("card mt-5")
            }
            .header {
                Link().href("/assets/css/vendor/summernote-bs4.css").relationship(.stylesheet).type("text/css")
                Link().href("https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0/katex.min.css").relationship(.stylesheet)
            }
            .scripts {
                Script().source("/assets/js/vendor/summernote-bs4.min.js")
                Script().source("https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0/katex.min.js")
                Script().source("/assets/js/vendor/summernote-math.js")
                IF(context.topicInfo.isDefined) {
                    Script().source("/assets/js/topic/edit.js")
                    Script().source("/assets/js/topic/delete.js")
                }.else {
                    Script().source("/assets/js/topic/create.js")
                }
            }
        }

        struct ActionButtons: HTMLComponent {

            @TemplateValue(Topic?.self)
            var topic

            var body: HTML {
                Unwrap(topic) { topic in
                    Button {
                        " Lagre"
                    }
                    .type(.button)
                    .on(click: "editTopic(" + topic.id + ")")
                    .class("btn btn-success mb-3 mt-3 mr-2")

                    Button {
                        " Slett"
                    }
                    .type(.button)
                    .on(click: "deleteTopic(" + topic.id + ")")
                    .class("btn btn-danger mb-3 mt-3")
                }.else {
                    Button {
                        " Lagre"
                    }
                    .type(.button)
                    .on(click: "createTopic()")
                    .class("btn btn-success btn-rounded mb-3 mt-3")
                }
            }
        }
    }
}
