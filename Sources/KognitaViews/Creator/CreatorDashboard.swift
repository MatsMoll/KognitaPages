//
//  CreatorDashboard.swift
//  App
//
//  Created by Mats Mollestad on 27/02/2019.
//
// swiftlint:disable line_length nesting

import BootstrapKit
import KognitaCore
import Foundation

public protocol CreatorTaskContentable {
    var creatorName: String? { get }
    var subjectName: String { get }
    var subjectID: Int { get }
    var topicName: String { get }
    var topicID: Int { get }
    var taskID: Int { get }
    var question: String { get }
    var status: String { get }
    var deletedAt: Date? { get }
    var taskTypePath: String { get }
}

public struct CreatorTemplates {

    public struct Dashboard: HTMLTemplate {

        public struct Context {
            let user: User
            let tasks: [CreatorTaskContentable]
            let timelyTopics: [TimelyTopic]

            public init(user: User, tasks: [CreatorTaskContentable], timelyTopics: [TimelyTopic]) {
                self.user = user
                self.tasks = tasks
                self.timelyTopics = timelyTopics
            }
        }

        public init() {}

        public let context: TemplateValue<Context> = .root()

        let createMultipleTaskUrl: HTML = "create-task-select-subject?taskType=multiple"
        let createInputTaskUrl: HTML = "create-task-select-subject?taskType=input"
        let createFlashCardTaskUrl: HTML = "create-task-select-subject?taskType=flash-card"

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Hjemmeside", description: "Hjemmeside"))
            ) {
                Row {
                    Div {
                        Div {
                            Div {
                                OrderedList {
                                    ListItem {
                                        "Lag innhold"
                                    }.class("breadcrumb-item active")
                                }.class("breadcrumb m-0")
                            }.class("page-title-right")
                            H4 {
                                "Lag innhold"
                            }.class("page-title")
                        }.class("page-title-box")
                    }.class("col-12")
                }
                Row {
                    IF(context.timelyTopics.count > 0) {
                        Div {
                            Div {
                                H3 {
                                    "Mest kritiske temaer"
                                }.class("mt-2 mb-2")
                            }.class("page-title-box")
                        }.class("col-12")

                        ForEach(in: context.timelyTopics) { topic in
                            TimelyTopicView(topic: topic)
                        }
                    }
                    Div {
                        H3 {
                            "Dine oppgaver"
                        }.class("mb-2")
                        Card {
                            Anchor {
                                Button {
                                    "Lag et fag"
                                }.class("btn btn-primary")
                            }.href("/subjects/create")
                            Anchor {
                                Button {
                                    "Lag et tema"
                                }.class("btn btn-primary ml-2")
                            }.href("create-topic-select-subject")
                            Anchor {
                                Button {
                                    "Lag et undertema"
                                }.class("btn btn-primary ml-2")
                            }.href("subtopic-select-subject")
                            Anchor {
                                Button {
                                    "Lag flervalgsoppgave"
                                }.type("button").class("btn btn-success ml-2")
                            }.href(createMultipleTaskUrl)
                            Anchor {
                                Button {
                                    "Lag matteoppgave"
                                }
                                .type(.button)
                                .class("btn btn-success ml-2")
                            }.href(createInputTaskUrl)
                            Anchor {
                                Button {
                                    "Lag kortsvarsoppgave"
                                }
                                .type(.button)
                                .class("btn btn-success ml-2")
                            }.href(createFlashCardTaskUrl)
                            IF(context.tasks.count > 0) {
                                Div {
                                    Table {
                                        TableHead {
                                            TableRow {
                                                TableHeader {
                                                    Div {
                                                        Input()
                                                            .type(.checkbox)
                                                            .class("custom-control-input")
                                                            .id("customCheck1")
                                                        Label {
                                                            " "
                                                        }.class("custom-control-label").for("customCheck1")
                                                    }.class("custom-control custom-checkbox")
                                                }
                                                .class("all")
                                                .style(css: "width: 20px;")

                                                TableHeader {
                                                    "Fag"
                                                }
                                                .class("all")

                                                TableHeader {
                                                    "Tema"
                                                }
                                                TableHeader {
                                                    "Spørsmål"
                                                }
                                                TableHeader {
                                                    "Status"
                                                }
                                                TableHeader {
                                                    "Handlinger"
                                                }
                                            }
                                        }
                                        .class("thead-light")
                                        TableBody {
                                            ForEach(in: context.tasks) { task in
                                                TaskRow(task: task)
                                            }
                                        }
                                    }.class("table table-centered w-100 dt-responsive nowrap").id("products-datatable")
                                }.class("table-responsive")
                            }.else {
                                Div {
                                    H3 {
                                        "Du har ikke laget noen oppgaver enda."
                                    }
                                    .text(alignment: .center)
                                }
                                .column(width: .twelve)
                            }
                        }
                    }
                    .class("col-12")
                }
            }
            .scripts {
                Script().source("/assets/js/delete-task.js")
            }
            .active(path: "/creator/dashboard")
        }
    }

    struct TimelyTopicView: HTMLComponent {

        let topic: TemplateValue<TimelyTopic>

        var url: HTML { "/creator/overview/topics/" + topic.topicID }

        var body: HTML {
            Div {
                Anchor {
                    Card {
                        H3 {
                            topic.topicName
                        }
                        .class("mt-3 mb-3 text-dark")
                        P {
                            Span {
                                "Finnes "
                                topic.numberOfTasks
                                " oppgaver"
                            }
                            .class("text-nowrap")
                        }
                        .class("mb-2 text-muted")

                        Button {
                            "lag oppgave"
                        }
                        .class("btn btn-success mb-2")
                    }
                    .class("widget-flat")
                }
                .href(url)
            }
            .class("col-lg-3 col-md-4")
        }
    }

    struct TaskRow: HTMLComponent {

        let task: TemplateValue<CreatorTaskContentable>

        var url: HTML { "/" + task.taskTypePath + "/" + task.taskID }
        var editUrl: HTML { "/creator/" + task.taskTypePath + "/" + task.taskID + "/edit" }

        var body: HTML {
            TableRow {
                TableCell {
                    Div {
                        Input()
                            .type(.checkbox)
                            .class("custom-control-input")
                            .id("customCheck2")
                        Label {
                            " "
                        }
                        .class("custom-control-label")
                        .for("customCheck2")
                    }
                    .class("custom-control custom-checkbox")
                }
                TableCell {
                    task.subjectName
                }
                .text(color: .muted)
                TableCell {
                    task.topicName
                }
                .text(color: .muted)
                TableCell {
                    Anchor {
                        task.question
                    }
                    .href(url)
                    .text(color: .muted)
                }
                TableCell {
                    task.status
                    Badge {
                        "Kommer snart"
                    }
                }
                TableCell {
                    Anchor {
                        Italic().class("dripicons-view-thumb")
                    }
                    .href(url)
                    .class("action-icon")
                    Anchor {
                        Italic().class("dripicons-document-edit")
                    }
                    .href(editUrl)
                    .class("action-icon")
                    Input()
                        .id(task.taskID)
                        .type(.hidden)
                        .value(task.taskTypePath)
                    Anchor {
                        Italic().class("dripicons-document-delete")
                    }
                    .on(click: "deleteTask(" + task.taskID + ");")
                    .class("action-icon")
                    .href("#")
                }.class("table-action")
            }
        }
    }
}
