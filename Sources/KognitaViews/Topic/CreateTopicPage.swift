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

extension Subject {
    var subjectUri: String {
        "/subjects/\(id ?? 0)"
    }
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
                self.topicInfo = topicInfo
            }
            
            var baseContent: BaseTemplateContent {
                .init(
                    title: title,
                    description: title
                )
            }
            
            var title: String {
                if topicInfo != nil {
                    return "Rediger undertema"
                } else {
                    return "Lag et undertema"
                }
            }
        }

        var breadcrumbs: [BreadcrumbItem] {
            [
                BreadcrumbItem(link: "/subjects", title: "Fagoversikt"),
                BreadcrumbItem(link: ViewWrapper(view: context.subject.subjectUri), title: ViewWrapper(view: context.subject.name))
            ]
        }

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: context.baseContent
            ) {
                PageTitle(title: context.baseContent.title, breadcrumbs: breadcrumbs)
                Card {
                    DismissableError()
                    Form {
                        FormGroup(label: "Navn") {
                            Input()
                                .type(.text)
                                .id("create-topic-name")
                                .placeholder("Likninger med en ukjent")
                                .required()
                                .value(Unwrap(context.topicInfo) { $0.name })
                        }
                        .description {
                            Small {
                                "Kun tillatt med bokstaver, tall og mellomrom"
                            }
                        }

                        FormGroup(label: "Kapittel") {
                            Input()
                                .type(.number)
                                .id("create-topic-chapter")
                                .placeholder("1")
                                .required()
                                .value(Unwrap(context.topicInfo) { $0.chapter })
                        }
                        .description {
                            Small {
                                "Kan ikke ha samme verdi som noen andre kapitler"
                            }
                        }

                        ActionButtons(topic: context.topicInfo)
                    }
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
                        " Lagre endringer"
                    }
                    .type(.button)
                    .on(click: "editTopic(" + topic.id + ")")
                    .button(style: .success)
                    .isRounded()
                    .margin(.two, for: .right)

                    Button {
                        " Slett"
                    }
                    .type(.button)
                    .on(click: "deleteTopic(" + topic.id + ")")
                    .button(style: .danger)
                    .isRounded()
                }.else {
                    Button {
                        " Lagre"
                    }
                    .type(.button)
                    .on(click: "createTopic()")
                    .button(style: .success)
                    .isRounded()
                }
            }
        }
    }
}
