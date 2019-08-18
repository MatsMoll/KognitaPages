//
//  CreatorTopicPage.swift
//  App
//
//  Created by Mats Mollestad on 02/03/2019.
//

import HTMLKit
import KognitaCore


public struct CreatorTopicPage: LocalizedTemplate {

    public init() {}

    public static var localePath: KeyPath<CreatorTopicPage.Context, String>? = \.locale

    public enum LocalizationKeys: String {
        case none
    }

    public struct Context {
        let locale = "nb"
        let base: ContentBaseTemplate.Context
        let tasks: [CreatorTaskContent]
        let topic: Topic
        let subject: Subject

        public init(user: User, subject: Subject, topic: Topic, tasks: [CreatorTaskContent]) {
            self.base = .init(user: user, title: topic.name)
            self.topic = topic
            self.subject = subject
            self.tasks = tasks
        }
    }

    public func build() -> CompiledTemplate {

        let createMultipleTaskUrl: [CompiledTemplate] = [
            "/creator/subjects/", variable(\.subject.id), "/task/multiple/create?topicId=", variable(\.topic.id)
        ]
        let createInputTaskUrl: [CompiledTemplate] = [
            "/creator/subjects/", variable(\.subject.id), "/task/input/create?topicId=", variable(\.topic.id)
        ]
        let createFlashCardTaskUrl: [CompiledTemplate] = [
            "/creator/subjects/", variable(\.subject.id), "/task/flash-card/create?topicId=", variable(\.topic.id)
        ]

        return embed(
            ContentBaseTemplate(
                body:

                // Breadcrumb
                div.class("row").child(
                    div.class("col-12").child(
                        div.class("page-title-box").child(
                            div.class("page-title-right").child(
                                ol.class("breadcrumb m-0").child(
                                    li.class("breadcrumb-item active").child(
                                        variable(\.subject.name)
                                    )
                                )
                            ),
                            h4.class("page-title").child(
                                variable(\.subject.name)
                            )
                        )
                    )
                ),

                // Topic description card
                div.class("row").child(
                    div.class("col-12").child(
                        div.class("card d-block").child(
                            div.class("card-body").child(

                                // Edit button
                                a.href("/creator/subjects/", variable(\.subject.id), "/topics/", variable(\.topic.id), "/edit").child(
                                    button.class("btn btn-primary float-right").child(
                                        "Rediger"
                                    )
                                ),

                                // Title etc.
                                h3.class("mt-0").child(
                                    variable(\.topic.name)
                                ),
                                h5.child(
                                    "Tema beskrivelse:"
                                ),
                                p.class("text-muted mb-2").child(
                                    variable(\.topic.description, escaping: .unsafeNone)
                                )
                            )
                        )
                    )
                ),

                // Table
                div.class("row").child(

                    div.class("col-12").child(

                        h3.class("mb-2").child(
                            "Eksisterende oppgaver"
                        ),

                        div.class("card").child(
                            div.class("card-body").child(

                                renderIf(
                                    \.tasks.count > 0,

                                    // Create Multiple Choise Task
                                    a.href(createMultipleTaskUrl).child(
                                        button.type("button").class("btn btn-success mb-2 mr-1").child(
                                            i.class("mdi mdi-trophy"),
                                            " Flervalgsoppgave"
                                        )
                                    ),

                                    // Create Number Input Task
                                    a.href(createInputTaskUrl).child(
                                        button.type("button").class("btn btn-success mb-2 mr-1").child(
                                            i.class("mdi mdi-trophy"),
                                            " Innskrivningsoppgave"
                                        )
                                    ),

                                    // Create Flash Card
                                    a.href(createFlashCardTaskUrl).child(
                                        button.type("button").class("btn btn-success mb-2 mr-1").child(
                                            i.class("mdi mdi-trophy"),
                                            " Ordkort"
                                        )
                                    ),

                                    // Existing Tasks Table
                                    div.class("table-responsive").child(
                                        table.class("table table-centered w-100 dt-responsive nowrap").id("products-datatable").child(
                                            thead.class("thead-light").child(
                                                tr.child(
                                                    th.child(
                                                        "Spørsmål"
                                                    ),
                                                    th.child(
                                                        "Forfatter"
                                                    ),
                                                    th.child(
                                                        "Status"
                                                    ),
                                                    th.child(
                                                        "Handlinger"
                                                    )
                                                )
                                            ),
                                            tbody.child(
                                                forEach(
                                                    in:     \.tasks,
                                                    render: TaskRow()
                                                )
                                            )
                                        )
                                    )
                                ).else(
                                    div.class("col-12").child(
                                        h3.child("text-center").child(
                                            "Det er ingen oppgaver enda."
                                        ),
                                        div.class("offset-md-4 col-md-4").child(

                                            // Create Multiple Choise Task
                                            a.href(createMultipleTaskUrl).child(
                                                button.type("button").class("btn btn-success mb-2 mr-1").child(
                                                    i.class("mdi mdi-trophy"),
                                                    " Flervalgsoppgave"
                                                )
                                            ),

                                            // Create Number Input Task
                                            a.href(createInputTaskUrl).child(
                                                button.type("button").class("btn btn-success mb-2 mr-1").child(
                                                    i.class("mdi mdi-trophy"),
                                                    " Innskrivningsoppgave"
                                                )
                                            ),

                                            // Create Flash Card
                                            a.href(createFlashCardTaskUrl).child(
                                                button.type("button").class("btn btn-success mb-2 mr-1").child(
                                                    i.class("mdi mdi-trophy"),
                                                    " Ordkort"
                                                )
                                            )
                                        )
                                    )
                                )
                            )
                        )
                    )
                ),

                scripts: [
                    script.src("/assets/js/delete-task.js")
                ]
            ),
            withPath: \.base)
    }


    // MARK: - Subviews

    struct TaskRow: ContextualTemplate {

        typealias Context = CreatorTaskContent

        func build() -> CompiledTemplate {
            let url: [CompiledTemplate] = ["/", variable(\.taskTypePath), "/", variable(\.taskID)]
            let editUrl: [CompiledTemplate] = ["/creator/", variable(\.taskTypePath), "/", variable(\.taskID), "/edit"]
            return
                tr.child(
                    td.child(
                        a.href(url).class("text-muted").child(
                            variable(\.question)
                        )
                    ),
                    td.class("text-muted").child(
                        renderIf(
                            isNotNil: \Context.creatorName,
                            variable(\.creatorName)
                        ).else(
                            "Ukjent"
                        )
                    ),
                    td.child(
                        renderIf(
                            \.isOutdated,

                            div.class("badge badge-danger").child(
                                "Inaktiv"
                            )
                        ).else(
                            div.class("badge badge-success").child(
                                "Godkjent"
                            )
                        )
                    ),
                    td.class("table-action").child(
                        a.href(url).class("action-icon").child(
                            i.class("dripicons-view-thumb")
                        ),
                        a.href(editUrl).class("action-icon").child(
                            i.class("dripicons-document-edit")
                        ),
                        input.id(variable(\.taskID)).type("hidden").value(variable(\.taskTypePath)),
                        a.onclick("deleteTask(", variable(\.taskID), ");").class("action-icon").href("#").child(
                            i.class("dripicons-document-delete")
                        )
                    )
            )
        }
    }
}
