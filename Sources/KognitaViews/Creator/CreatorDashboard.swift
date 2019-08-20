//
//  CreatorDashboard.swift
//  App
//
//  Created by Mats Mollestad on 27/02/2019.
//
// swiftlint:disable line_length nesting

import HTMLKit
import KognitaCore
import Foundation

public protocol CreatorTaskContent {
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

public struct CreatorDashboard: LocalizedTemplate {

    public init() {}

    public static var localePath: KeyPath<CreatorDashboard.Context, String>? = \.locale

    public enum LocalizationKeys: String {
        case none
    }

    public struct Context {
        let locale = "nb"
        let base: ContentBaseTemplate.Context
        let tasks: [CreatorTaskContent]
        let timelyTopics: [TimelyTopic]

        public init(user: User, tasks: [CreatorTaskContent], timelyTopics: [TimelyTopic]) {
            self.base = .init(user: user, title: "Hjemmeside")
            self.tasks = tasks
            self.timelyTopics = timelyTopics
        }
    }

    public func build() -> CompiledTemplate {

        let createMultipleTaskUrl: [CompiledTemplate] = [
            "create-task-select-subject?taskType=multiple"
        ]
        let createInputTaskUrl: [CompiledTemplate] = [
            "create-task-select-subject?taskType=input"
        ]
        let createFlashCardTaskUrl: [CompiledTemplate] = [
            "create-task-select-subject?taskType=flash-card"
        ]

        return embed(
            ContentBaseTemplate(
                body:

                div.class("row").child(
                    div.class("col-12").child(
                        div.class("page-title-box").child(
                            div.class("page-title-right").child(
                                ol.class("breadcrumb m-0").child(
                                    li.class("breadcrumb-item active").child(
                                        "Lag innhold"
                                    )
                                )
                            ),
                            h4.class("page-title").child(
                                "Lag innhold"
                            )
                        )
                    )
                ),

//                div.class("row").child(
//                    div.class("col-sm-12").child(
//                        div.class("card bg-primary").child(
//                            div.class("card-body profile-user-box").child(
//                                div.class("row").child(
//                                    div.class("col-sm-8").child(
//                                        div.class("media").child(
//                                            span.class("float-left m-2 mr-4").child(
//                                                img.src("/assets/images/users/avatar-2.jpg").style("height: 100px;").alt("").class("rounded-circle img-thumbnail")
//                                            ),
//                                            div.class("media-body").child(
//                                                h4.class("mt-1 mb-1 text-white").child(
//                                                    variable(\.base.user.name)
//                                                ),
//                                                p.class("font-13 text-white-50").child(
//                                                    renderIf(
//                                                        \.base.user.isCreator,
//                                                        "Innholdskaper"
//                                                        ).else(
//                                                            "Elev"
//                                                    )
//                                                ),
//                                                ul.class("mb-0 list-inline text-light").child(
//                                                    li.class("list-inline-item mr-3").child(
//                                                        h5.class("mb-1").child(
//                                                            "$ 25,184"
//                                                        ),
//                                                        p.class("mb-0 font-13 text-white-50").child(
//                                                            "Noe info"
//                                                        )
//                                                    ),
//                                                    li.class("list-inline-item").child(
//                                                        h5.class("mb-1").child(
//                                                            "5482"
//                                                        ),
//                                                        p.class("mb-0 font-13 text-white-50").child(
//                                                            "Hvor mange oppgaver registrert?"
//                                                        )
//                                                    )
//                                                )
//                                            )
//                                        )
//                                    ),
//
//                                    div.class("col-sm-4").child(
//                                        div.class("text-center mt-sm-0 mt-3 text-sm-right").child(
//                                            button.type("button").class("btn btn-light").child(
//                                                "Rediger Profil"
//                                            )
//                                        )
//                                    )
//                                )
//                            )
//                        )
//                    )
//                ),

                // Table
                div.class("row").child(

                    renderIf(
                        \.timelyTopics.count > 0,

                        div.class("col-12").child(
                            div.class("page-title-box").child(
                                h3.class("mt-2 mb-2").child("Mest kritiske temaer")
                            )
                        ),
                        forEach(in:     \.timelyTopics,
                                render: TimelyTopicCard()
                        )
                    ),

                    div.class("col-12").child(

                        h3.class("mb-2").child(
                            "Dine oppgaver"
                        ),

                        div.class("card").child(
                            div.class("card-body").child(

                                a.href("/subjects/create").child(
                                    button.class("btn btn-primary").child(
                                        "Lag et fag"
                                    )
                                ),

                                a.href("create-topic-select-subject").child(
                                    button.class("btn btn-primary ml-2").child(
                                        "Lag et tema"
                                    )
                                ),

                                // Create Multiple Choise Task
                                a.href(createMultipleTaskUrl).child(
                                    button.type("button").class("btn btn-success ml-2").child(
                                        "Lag flervalgsoppgave"
                                    )
                                ),

                                // Create Number Input Task
                                a.href(createInputTaskUrl).child(
                                    button.type("button").class("btn btn-success ml-2").child(
                                        "Lag innskrivningsoppgave"
                                    )
                                ),

                                // Create Flash Card
                                a.href(createFlashCardTaskUrl).child(
                                    button.type("button").class("btn btn-success ml-2").child(
                                        "Lag ordkort"
                                    )
                                ),

                                renderIf(
                                    \.tasks.count > 0,

                                    div.class("table-responsive").child(
                                        table.class("table table-centered w-100 dt-responsive nowrap").id("products-datatable").child(
                                            thead.class("thead-light").child(
                                                tr.child(
                                                    th.class("all").style("width: 20px;").child(
                                                        div.class("custom-control custom-checkbox").child(
                                                            input.type("checkbox").class("custom-control-input").id("customCheck1"),
                                                            label.class("custom-control-label").for("customCheck1").child(
                                                                " "
                                                            )
                                                        )
                                                    ),
                                                    th.class("all").child(
                                                        "Fag"
                                                    ),
                                                    th.child(
                                                        "Tema"
                                                    ),
                                                    th.child(
                                                        "Spørsmål"
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
                                                forEach(in:     \.tasks,
                                                        render: TaskRow()
                                                )
                                            )
                                        )
                                    )
                                ).else(
                                    div.class("col-12").child(
                                        h3.child("text-center").child(
                                            "Du har ikke laget noen oppgaver enda."
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

    struct TimelyTopicCard: ContextualTemplate {

        typealias Context = TimelyTopic

        func build() -> CompiledTemplate {

            let url: [CompiledTemplate] = ["/creator/overview/topics/", variable(\Context.topicID)]
            return
                div.class("col-lg-3 col-md-4").child(
                    div.class("card widget-flat").child(
                        a.href(url).child(
                            div.class("card-body").child(
//                                h5.class("text-muted font-weight-normal mt-0").title("Fag navn").child(
//                                    variable(\.subjectName)
//                                ),
                                h3.class("mt-3 mb-3 text-dark").child(
                                    variable(\.topicName)
                                ),
                                p.class("mb-2 text-muted").child(
                                    span.class("text-nowrap").child(
                                        "Finnes ", variable(\.numberOfTasks), " oppgaver"
                                    )
                                ),
                                button.class("btn btn-success mb-2").child(
                                    "lag oppgave"
                                )
                            )
                        )
                    )
            )
        }
    }

    struct TaskRow: ContextualTemplate {

        typealias Context = CreatorTaskContent

        func build() -> CompiledTemplate {

            let url: [CompiledTemplate] = ["/", variable(\.taskTypePath), "/", variable(\.taskID)]
            let editUrl: [CompiledTemplate] = ["/creator/", variable(\.taskTypePath), "/", variable(\.taskID), "/edit"]
            return
                tr.child(
                    td.child(
                        div.class("custom-control custom-checkbox").child(
                            input.type("checkbox").class("custom-control-input").id("customCheck2"),
                            label.class("custom-control-label").for("customCheck2").child(
                                " "
                            )
                        )
                    ),
                    td.class("text-muted").child(
                        variable(\.subjectName)
                    ),
                    td.class("text-muted").child(
                        variable(\.topicName)
                    ),
                    td.child(
                        a.href(url).class("text-muted").child(
                            variable(\.question)
                        )
                    ),
                    td.child(
                        variable(\.status),
                        span.class("badge")
                            .if(\.deletedAt != nil, add: .class("badge-danger"))
                            .if(\.deletedAt == nil, add: .class("badge-success")).child(
                                renderIf(isNil: \.deletedAt,
                                    "Godkjent"
                                ).else(
                                    "Inaktiv"
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

    struct CreateTaskModal: ContextualTemplate {

        struct SubjectRow: ContextualTemplate {

            typealias Context = Subject

            func build() -> CompiledTemplate {
                return option.value(variable(\.id)).child(
                    variable(\.name)
                )
            }
        }

        static let modalID = "create-task-modal"

        typealias Context = [Subject]

        func build() -> CompiledTemplate {
            let id = CreateTaskModal.modalID
            return
                div.class("modal fade").id(id).tabindex("-1").role("dialog").ariaLabelledby(id).ariaHidden(true).child(
                    div.class("modal-dialog modal-dialog-centered modal-lg").child(
                        div.class("modal-content").child(
                            div.class("modal-header bg-light").child(
                                h4.class("modal-title").id(id).child(
                                    "Lag en flervalgs oppgave"
                                ),
                                button.type("button").class("close").dataDismiss("modal").ariaHidden(true).child(
                                    "×"
                                )
                            ),
                            div.class("modal-body").child(
                                div.class("p-2").child(

                                    h5.class("mt-0").child(
                                        "Velg fag:"
                                    ),
                                    // Selector
                                    select.id("subject-selector").class("form-control select2").dataToggle("select2").dataPlaceholder("Velg ...").child(
                                        forEach(render: SubjectRow())
                                    ),
                                    div.class("mt-4").child(
                                        button.type("button").onclick("redirectToMultiple();").class("btn btn-primary btn-rounded mb-3").child(
                                            " Velg fag"
                                        )
                                    )
                                )
                            )
                        )
                    )
            )
        }
    }
}
