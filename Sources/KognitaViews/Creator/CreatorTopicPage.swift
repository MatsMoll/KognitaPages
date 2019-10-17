//
//  CreatorTopicPage.swift
//  App
//
//  Created by Mats Mollestad on 02/03/2019.
//

import BootstrapKit
import KognitaCore

extension CreatorTemplates {
    public struct TopicDetails: TemplateView {

        public struct Context {
            let user: User
            let base: BaseTemplateContent
            let tasks: [CreatorTaskContent]
            let topic: Topic
            let subject: Subject

            public init(user: User, subject: Subject, topic: Topic, tasks: [CreatorTaskContent]) {
                self.user = user
                self.base = .init(title: topic.name, description: topic.name)
                self.topic = topic
                self.subject = subject
                self.tasks = tasks
            }
        }

        public init() {}

        public let context: RootValue<Context> = .root()

        var createMultipleTaskUrl: View {
            "/creator/subjects/" + context.subject.id + "/task/multiple/create?topicId=" + context.topic.id
        }
        var createInputTaskUrl: View {
            "/creator/subjects/" + context.subject.id + "/task/input/create?topicId=" + context.topic.id
        }
        var createFlashCardTaskUrl: View {
            "/creator/subjects/" + context.subject.id + "/task/flash-card/create?topicId=" + context.topic.id
        }

        public var body: View {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: context.base,
                content:
                Row {
                    Div {
                        Div {
                            Div {
                                OrderdList {
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
                } +
                Row {
                    Div {
                        Div {
                            Div {
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
                                P {
                                    context.topic.description
                                        .escaping(.unsafeNone)
                                }.class("text-muted mb-2")
                            }.class("card-body")
                        }.class("card d-block")
                    }.class("col-12")
                } +
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
                },

                scripts: [
                    Script().source("/assets/js/delete-task.js")
                ]
            )
        }
    }
}

//public struct CreatorTopicPage: LocalizedTemplate {
//
//    public init() {}
//
//    public static var localePath: KeyPath<CreatorTopicPage.Context, String>? = \.locale
//
//    public enum LocalizationKeys: String {
//        case none
//    }
//
//    public struct Context {
//        let locale = "nb"
//        let base: ContentBaseTemplate.Context
//        let tasks: [CreatorTaskContent]
//        let topic: Topic
//        let subject: Subject
//
//        public init(user: User, subject: Subject, topic: Topic, tasks: [CreatorTaskContent]) {
//            self.base = .init(user: user, title: topic.name)
//            self.topic = topic
//            self.subject = subject
//            self.tasks = tasks
//        }
//    }
//
//    public func build() -> CompiledTemplate {
//
//        let createMultipleTaskUrl: [CompiledTemplate] = [
//            "/creator/subjects/", variable(\.subject.id), "/task/multiple/create?topicId=", variable(\.topic.id)
//        ]
//        let createInputTaskUrl: [CompiledTemplate] = [
//            "/creator/subjects/", variable(\.subject.id), "/task/input/create?topicId=", variable(\.topic.id)
//        ]
//        let createFlashCardTaskUrl: [CompiledTemplate] = [
//            "/creator/subjects/", variable(\.subject.id), "/task/flash-card/create?topicId=", variable(\.topic.id)
//        ]
//
//        return embed(
//            ContentBaseTemplate(
//                body:
//
//                // Breadcrumb
//                div.class("row").child(
//                    div.class("col-12").child(
//                        div.class("page-title-box").child(
//                            div.class("page-title-right").child(
//                                ol.class("breadcrumb m-0").child(
//                                    li.class("breadcrumb-item active").child(
//                                        variable(\.subject.name)
//                                    )
//                                )
//                            ),
//                            h4.class("page-title").child(
//                                variable(\.subject.name)
//                            )
//                        )
//                    )
//                ),
//
//                // Topic description card
//                div.class("row").child(
//                    div.class("col-12").child(
//                        div.class("card d-block").child(
//                            div.class("card-body").child(
//
//                                // Edit button
//                                a.href("/creator/subjects/", variable(\.subject.id), "/topics/", variable(\.topic.id), "/edit").child(
//                                    button.class("btn btn-primary float-right").child(
//                                        "Rediger"
//                                    )
//                                ),
//
//                                // Title etc.
//                                h3.class("mt-0").child(
//                                    variable(\.topic.name)
//                                ),
//                                h5.child(
//                                    "Tema beskrivelse:"
//                                ),
//                                p.class("text-muted mb-2").child(
//                                    variable(\.topic.description, escaping: .unsafeNone)
//                                )
//                            )
//                        )
//                    )
//                ),
//
//                // Table
//                div.class("row").child(
//
//                    div.class("col-12").child(
//
//                        h3.class("mb-2").child(
//                            "Eksisterende oppgaver"
//                        ),
//
//                        div.class("card").child(
//                            div.class("card-body").child(
//
//                                // Create Multiple Choise Task
//                                a.href(createMultipleTaskUrl).child(
//                                    button.type("button").class("btn btn-success mb-2 mr-1").child(
//                                        i.class("mdi mdi-trophy"),
//                                        " Flervalgsoppgave"
//                                    )
//                                ),
//
//                                // Create Number Input Task
//                                a.href(createInputTaskUrl).child(
//                                    button.type("button").class("btn btn-success mb-2 mr-1").child(
//                                        i.class("mdi mdi-trophy"),
//                                        " Innskrivningsoppgave"
//                                    )
//                                ),
//
//                                // Create Flash Card
//                                a.href(createFlashCardTaskUrl).child(
//                                    button.type("button").class("btn btn-success mb-2 mr-1").child(
//                                        i.class("mdi mdi-trophy"),
//                                        " Ordkort"
//                                    )
//                                ),
//
//                                renderIf(
//                                    \.tasks.count > 0,
//
//                                    // Existing Tasks Table
//                                    div.class("table-responsive").child(
//                                        table.class("table table-centered w-100 dt-responsive nowrap").id("products-datatable").child(
//                                            thead.class("thead-light").child(
//                                                tr.child(
//                                                    th.child(
//                                                        "Spørsmål"
//                                                    ),
//                                                    th.child(
//                                                        "Forfatter"
//                                                    ),
//                                                    th.child(
//                                                        "Status"
//                                                    ),
//                                                    th.child(
//                                                        "Handlinger"
//                                                    )
//                                                )
//                                            ),
//                                            tbody.child(
//                                                forEach(
//                                                    in:     \.tasks,
//                                                    render: TaskRow()
//                                                )
//                                            )
//                                        )
//                                    )
//                                ).else(
//                                    h3.child("text-center").child(
//                                        "Det er ingen oppgaver enda."
//                                    )
//                                )
//                            )
//                        )
//                    )
//                ),
//
//                scripts: [
//                    script.src("/assets/js/delete-task.js")
//                ]
//            ),
//            withPath: \.base)
//    }
//
//
//    // MARK: - Subviews
//
//    struct TaskRow: ContextualTemplate {
//
//        typealias Context = CreatorTaskContent
//
//        func build() -> CompiledTemplate {
//            let url: [CompiledTemplate] = ["/", variable(\.taskTypePath), "/", variable(\.taskID)]
//            let editUrl: [CompiledTemplate] = ["/creator/", variable(\.taskTypePath), "/", variable(\.taskID), "/edit"]
//            return
//                tr.child(
//                    td.child(
//                        a.href(url).class("text-muted").child(
//                            variable(\.question)
//                        )
//                    ),
//                    td.class("text-muted").child(
//                        renderIf(
//                            isNotNil: \Context.creatorName,
//                            variable(\.creatorName)
//                        ).else(
//                            "Ukjent"
//                        )
//                    ),
//                    td.child(
//                        renderIf(
//                            \.deletedAt != nil,
//
//                            div.class("badge badge-danger").child(
//                                "Inaktiv"
//                            )
//                        ).else(
//                            div.class("badge badge-success").child(
//                                "Godkjent"
//                            )
//                        )
//                    ),
//                    td.class("table-action").child(
//                        a.href(url).class("action-icon").child(
//                            i.class("dripicons-view-thumb")
//                        ),
//                        a.href(editUrl).class("action-icon").child(
//                            i.class("dripicons-document-edit")
//                        ),
//                        input.id(variable(\.taskID)).type("hidden").value(variable(\.taskTypePath)),
//                        a.onclick("deleteTask(", variable(\.taskID), ");").class("action-icon").href("#").child(
//                            i.class("dripicons-document-delete")
//                        )
//                    )
//            )
//        }
//    }
//}
