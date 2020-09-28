//
//  ModifyTopicsTemplate.swift
//  KognitaViews
//
//  Created by Mats Mollestad on 07/09/2020.
//

extension Topic.Templates {
    public struct Modify: HTMLTemplate {

        public struct Context {
            let user: User
            let subject: Subject
            let topics: [Topic]

            public init(user: User, subject: Subject, topics: [Topic]) {
                self.user = user
                self.subject = subject
                self.topics = topics
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
                baseContext: .constant(.init(title: "Temaer", description: "Rediger temaene", showCookieMessage: false))
            ) {
                PageTitle(title: "Rediger temaer", breadcrumbs: breadcrumbs)

                ContentStructure {
                    Text { "Temaer" }
                        .style(.heading2)

                    Div { ForEach(in: context.topics, content: TopicRow.init(context: )) }
                        .id("dragables")
                        .dragableElements(onDrag: "topicsDidChange")
                }
                .secondary {
                    Card {
                        Text { "Handlinger" }
                            .style(.heading3)

                        Button {
                            "Lagre"
                            MaterialDesignIcon(.check)
                                .margin(.one, for: .left)
                        }
                        .button(style: .success)
                        .on(click: "saveTopics()")

                        Button {
                            "Nytt tema"
                            MaterialDesignIcon(.note)
                                .margin(.one, for: .left)
                        }
                        .button(style: .primary)
                        .toggle(modal: .id("create-topic"))
                        .margin(.one, for: .left)

                        Modal(title: "Nytt tema", id: "create-topic") {
                            Form {
                                FormGroup(label: "Navn") {
                                    Input()
                                        .type(.text)
                                        .id("create-topic-name")
                                        .placeholder("Likninger med en ukjent")
                                        .required()
                                }

                                Button {
                                    "Legg til"
                                    MaterialDesignIcon(.check)
                                    .margin(.one, for: .left)
                                }
                                .type(.button)
                                .button(style: .success)
                                .on(click: "addTopic();")

                                Button { "Lukk" }
                                    .button(style: .light)
                                    .dismissModal()
                                    .margin(.one, for: .left)
                            }
                        }

                        Modal(title: "Slett tema", id: "delete-topic") {

                            Input()
                                .type(.hidden)
                                .id("delete-topic-id")

                            Text {
                                "Dette vil slette alt innhold som finnes i "
                                Span().id("delete-topic-name")
                                ". Er du sikker på at du ønsker dette?"
                            }
                            .style(.lead)

                            Button {
                                "Slette tema og alt innhold"
                                MaterialDesignIcon(.delete)
                                    .margin(.one, for: .left)
                            }
                            .button(style: .danger)
                            .on(click: "deleteTopic();")

                            Button { "Behold tema" }
                                .button(style: .primary)
                                .dismissModal()
                                .margin(.one, for: .left)
                        }
                        .set(data: "topic-id", type: .input, to: "delete-topic-id")
                        .set(data: "topic-name", type: .node, to: "delete-topic-name")

                        Modal(title: "Rediger tema", id: "edit-topic") {

                            Input()
                                .type(.hidden)
                                .id("edit-topic-id")

                            Form {
                                FormGroup(label: "Navn") {
                                    Input()
                                        .type(.text)
                                        .id("edit-topic-name")
                                        .placeholder("Likninger med en ukjent")
                                        .required()
                                }
                            }

                            Button {
                                "Lagre"
                                MaterialDesignIcon(.check)
                                    .margin(.one, for: .left)
                            }
                            .button(style: .primary)
                            .on(click: "saveChanges();")

                            Button { "Lukk" }
                                .button(style: .light)
                                .margin(.one, for: .left)
                                .dismissModal()
                        }
                        .set(data: "topic-id", type: .input, to: "edit-topic-id")
                        .set(data: "topic-name", type: .input, to: "edit-topic-name")
                    }
                }
            }
            .scripts {
                Script {
"""
function topicsDidChange(el, target, src) {
var num = 1; $(".chapter").each(function(idx, elem) { $(elem).text(num++); }); }
"""
                }
                Script.dragula
                Script(source: "/assets/js/topic/create.js")
            }
        }

        public struct TopicRow: HTMLTemplate {

            public typealias Context = Topic

            @TemplateValue(Topic.self)
            public var context

            public init(context: TemplateValue<Context> = .root()) {
                self.context = context
            }

            public var body: HTML {
                Card {
                    Text { context.chapter }
                        .class("chapter")
                        .margin(.two, for: .right)

                    Text {
                        Span { context.name }.class("topic-name")

                        MaterialDesignIcon(.reorderHorizontal)
                            .float(.right)

                        Button {
                            "Slett"
                            MaterialDesignIcon(.delete)
                                .margin(.one, for: .left)
                        }
                        .button(style: .danger)
                        .toggle(modal: .id("delete-topic"))
                        .float(.right)
                        .data("topic-id", value: context.id)
                        .data("topic-name", value: context.name)
                        .margin(.three, for: .right)

                        Button {
                            "Rediger"
                            MaterialDesignIcon(.note)
                                .margin(.one, for: .left)
                        }
                        .button(style: .light)
                        .data("topic-id", value: context.id)
                        .data("topic-name", value: context.name)
                        .float(.right)
                        .margin(.one, for: .right)
                        .toggle(modal: .id("edit-topic"))
                    }
                    .margin(.two, for: .right)
                    .style(.lead)
                }
                .id(context.id)
            }
        }
    }
}
