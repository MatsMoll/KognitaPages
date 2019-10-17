//
//  TaskOverviewListTemplate.swift
//  App
//
//  Created by Mats Mollestad on 01/05/2019.
//
// swiftlint:disable line_length nesting

import HTMLKit
import KognitaCore

/// A HTML Template
//public struct TaskOverviewListTemplate: LocalizedTemplate {
//
//    public init() {}
//
//    public static var localePath: KeyPath<TaskOverviewListTemplate.Context, String>? = \.locale
//
//    public enum LocalizationKeys: String {
//        case none
//    }
//
//    /// The Context needed to present `TaskOverviewListTemplate`
//    public struct Context {
//        let locale = "nb"
//        let base: ContentBaseTemplate.Context
//
//        let subject: Subject
//        let topic: Topic
//
//        let results: [TaskResultOverview]
//
//        public init(user: User, subject: Subject, topic: Topic, results: [TaskResultOverview]) {
//            self.base = .init(user: user, title: "Oppgaver")
//            self.results = results
//            self.subject = subject
//            self.topic = topic
//        }
//    }
//
//    /// The html template to render
//    public func build() -> CompiledTemplate {
//        return embed(
//            ContentBaseTemplate(
//                body:
//
//                div.class("row").child(
//                    div.class("col-12").child(
//                        div.class("page-title-box").child(
//                            div.class("page-title-right").child(
//                                ol.class("breadcrumb m-0").child(
//                                    li.class("breadcrumb-item").child(
//                                        a.href("../subjects").child(
//                                            "Fag"
//                                        )
//                                    ),
//                                    li.class("breadcrumb-item").child(
//                                        a.href("../subjects/" + variable(\.subject.id)).child(
//                                            variable(\.subject.name)
//                                        )
//                                    ),
//                                    li.class("breadcrumb-item active").child(
//                                        variable(\.topic.name)
//                                    )
//                                )
//                            ),
//                            h4.class("page-title").child(
//                                variable(\.topic.name)
//                            )
//                        )
//                    )
//                ),
//
//                div.class("row").child(
//                    a.onclick("startPracticeSession(" + variable(\.topic.id) + ", " + variable(\.subject.id) + ");").href("#").child(
//
//                        button.type("button").class("btn btn-primary btn-rounded mb-3").child(
//                            i.class("mdi mdi-book-open-variant"),
//                            " Øv på " + variable(\.topic.name)
//                        )
//                    )
//                ),
//
//                div.class("row").child(
//                    div.class("col-12").child(
//                        div.class("card table-responsive").child(
//                            table.class("table table-centered w-100 dt-responsive nowrap").id("products-datatable").child(
//                                thead.class("thead-light").child(
//                                    tr.child(
//                                        th.child(
//                                            "Oppgave"
//                                        ),
//                                        th.child(
//                                            "Sist utført"
//                                        ),
//                                        th.child(
//                                            "Score"
//                                        ),
//                                        th.child(
//                                            "Repiter om"
//                                        )
//                                    )
//                                ),
//                                tbody.child(
//                                    forEach(
//                                        in: \.results,
//                                        render: TaskRow()
//                                    )
//                                )
//                            )
//                        )
//                    )
//                ),
//
//                scripts:
//                script.src("/assets/js/practice-session-create.js")
//            ),
//            withPath: \.base
//        )
//    }
//
//
//    // MARK - Subviews
//
//    struct TaskCard: ContextualTemplate {
//
//        typealias Context = TaskResultOverview
//
//        func build() -> CompiledTemplate {
//            return div.class("card").child(
//                ""
//            )
//        }
//    }
//
//    struct TaskRow: ContextualTemplate {
//
//        typealias Context = TaskResultOverview
//
//        func build() -> CompiledTemplate {
//            return
//                tr.child(
//                    td.class("text-muted").child(
//                        variable(\.task.question)
//                    ),
//                    td.class("text-muted").child(
//                        renderIf(
//                            isNotNil: \.result,
//
//                            variable(\.result?.createdAt?.dayTimeString)
//                        ).else(
//                            "Ikke gjort"
//                        )
//                    ),
//                    td.class("text-muted").child(
//                        renderIf(isNotNil: \.result, variable(\.result?.resultScore))
//                    ),
//                    td.class("text-muted").child(
//
//                        renderIf(
//                            isNotNil: \.result,
//
//                            renderIf(
//                                isNotNil: \.result?.daysUntilRevisit,
//
//                                div.class("badge")
//                                    .if(\.result?.daysUntilRevisit < 3, add: .class("badge-danger"))
//                                    .if(\.result?.daysUntilRevisit < 11, add: .class("badge-warning"))
//                                    .if(\.result?.daysUntilRevisit > 10, add: .class("badge-success")).child(
//                                        variable(\.result?.daysUntilRevisit), " dager"
//                                )
//                            ).else(
//                                div.class("badge badge-success").child(
//                                    "Full kontroll"
//                                )
//                            )
//                        ).else(
//                            "Knapp for å gjøre oppgave her"
//                        )
//                    )
//            )
//        }
//    }
//}


public struct TaskResultOverview {
    public let result: TaskResult?
    public let task: Task

    public init(result: TaskResult?, task: Task) {
        self.result = result
        self.task = task
    }
}
