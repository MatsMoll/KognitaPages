//
//  CreatorTopicPage.swift
//  App
//
//  Created by Mats Mollestad on 02/03/2019.
//

import BootstrapKit
import KognitaCore

extension CreatorTemplates {
    public struct TopicDetails: HTMLTemplate {

        public struct Context {
            let user: User
            let base: BaseTemplateContent
            let tasks: [CreatorTaskContentable]
            let topic: Topic
            let subject: Subject

            public init(user: User, subject: Subject, topic: Topic, tasks: [CreatorTaskContentable]) {
                self.user = user
                self.base = .init(title: topic.name, description: topic.name)
                self.topic = topic
                self.subject = subject
                self.tasks = tasks
            }
        }

        public init() {}

        public let context: TemplateValue<Context> = .root()

        var createMultipleTaskUrl: HTML {
            "/creator/subjects/" + context.subject.id + "/task/multiple/create?topicId=" + context.topic.id
        }
        var createInputTaskUrl: HTML {
            "/creator/subjects/" + context.subject.id + "/task/input/create?topicId=" + context.topic.id
        }
        var createFlashCardTaskUrl: HTML {
            "/creator/subjects/" + context.subject.id + "/task/flash-card/create?topicId=" + context.topic.id
        }

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: context.base
            ) {
                Row {
                    Div {
                        Div {
                            Div {
                                OrderedList {
                                    ListItem {
                                        context.subject.name
                                    }.class("breadcrumb-item active")
                                }.class("breadcrumb m-0")
                            }.class("page-title-right")
                            H4 {
                                context.subject.name
                            }.class("page-title")
                        }.class("page-title-box")
                    }.class("col-12")
                }
                Row {
                    Div {
                        Card {
                            Anchor {
                                Button {
                                    "Rediger"
                                }.class("btn btn-primary float-right")
                            }.href("/creator/subjects/" + context.subject.id + "/topics/" + context.topic.id + "/edit")
                            H3 {
                                context.topic.name
                            }.class("mt-0")
                            H5 {
                                "Tema beskrivelse:"
                            }
                        }
                        .display(.block)
                    }.class("col-12")
                }
                Row {
                    Div {
                        H3 {
                            "Eksisterende oppgaver"
                        }.class("mb-2")
                        Div {
                            Div {
                                Anchor {
                                    Button {
                                        Italic().class("mdi mdi-trophy")
                                        " Flervalgsoppgave"
                                    }
                                    .type(.button)
                                    .class("btn btn-success mb-2 mr-1")
                                }.href(createMultipleTaskUrl)
                                Anchor {
                                    Button {
                                        Italic().class("mdi mdi-trophy")
                                        " Innskrivningsoppgave"
                                    }
                                    .type(.button)
                                    .class("btn btn-success mb-2 mr-1")
                                }.href(createInputTaskUrl)
                                Anchor {
                                    Button {
                                        Italic().class("mdi mdi-trophy")
                                        " Ordkort"
                                    }.type(.button).class("btn btn-success mb-2 mr-1")
                                }.href(createFlashCardTaskUrl)
                                IF(context.tasks.count > 0) {
                                    Div {
                                        Table {
                                            TableHead {
                                                TableRow {
                                                    TableHeader {
                                                        "Spørsmål"
                                                    }
                                                    TableHeader {
                                                        "Forfatter"
                                                    }
                                                    TableHeader {
                                                        "Status"
                                                    }
                                                    TableHeader {
                                                        "Handlinger"
                                                    }
                                                }
                                            }.class("thead-light")
                                            TableBody {
                                                ForEach(in: context.tasks) { task in
                                                    TaskRow(task: task)
                                                }
                                            }
                                        }.class("table table-centered w-100 dt-responsive nowrap").id("products-datatable")
                                    }.class("table-responsive")
                                }.else  {
                                    H3 {
                                        "Det er ingen oppgaver enda."
                                    }
                                    .text(alignment: .center)
                                }
                            }.class("card-body")
                        }.class("card")
                    }.class("col-12")
                }
            }
            .scripts {
                Script().source("/assets/js/delete-task.js")
            }
        }
    }
}
