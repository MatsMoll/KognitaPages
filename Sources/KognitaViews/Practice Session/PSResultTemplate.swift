//
//  PSResultTemplate.swift
//  App
//
//  Created by Mats Mollestad on 06/03/2019.
//
// swiftlint:disable line_length nesting

import HTMLKit
import Vapor
import KognitaCore

extension TimeInterval {
    var timeString: String {
        let sec = self.truncatingRemainder(dividingBy: 60)
        let min = (self / 60).truncatingRemainder(dividingBy: 60).rounded(.down)
        let hour = (self / 3600).rounded(.down)

        var timeString = ""
        if hour > 0 {
            timeString += "\(Int(hour)) t, "
        }
        if min > 0 {
            timeString += "\(Int(min)) min, "
        }
        return timeString + "\(Int(sec)) sek"
    }
}

public protocol TaskResultable {
    var topicName: String { get }
    var question: String { get }
    var revisitTime: Int { get }
    var resultDescription: String { get }
    var resultScore: Double? { get }
    var timeUsed: String { get }
    var date: Date? { get }
    var revisitDate: Date? { get }
}

public struct PSResultTemplate: LocalizedTemplate {

    public init() {}

    public static var localePath: KeyPath<PSResultTemplate.Context, String>? = \.locale

    public enum LocalizationKeys: String {
        case historyTitle = "history.title"
        case histogramTitle = "result.histogram.title"

        case numberOfTasks = "result.summary.task.amount"
        case goal = "result.summary.goal"
        case duration = "result.summary.duration"
        case accuracy = "result.summary.accuracy"

        case topicColumn = "result.summary.review.topic"
        case questionColumn = "result.summary.review.question"
        case resultColumn = "result.summary.review.result"
        case repeatColumn = "result.summary.review.repeat"
    }

    public struct Context {
        let locale = "nb"
        let base: ContentBaseTemplate.Context

        let numberOfTasks: InformationView.Context
        let goalProgress: InformationView.Context
        let timeUsed: InformationView.Context
        let accuracy: InformationView.Context

        let tasks: [TaskResultable]

        public init(user: User, tasks: [TaskResultable], progress: Int, timeUsed: TimeInterval) {

            var maxScore: Double = 0
            var achievedScore: Double = 0
            for task in tasks {
                if let score = task.resultScore {
                    maxScore += 1
                    achievedScore += score.clamped(to: 0...1)
                }
            }
            let accuracyScore = achievedScore / maxScore

            self.base = .init(user: user, title: "Resultat | Øving ")
            self.tasks = tasks
            self.numberOfTasks = .init(info: "\(tasks.count)")
            self.goalProgress = .init(info: "\(progress)%")
            self.timeUsed = .init(info: timeUsed.timeString)
            self.accuracy = .init(info: "\((10000 * accuracyScore).rounded() / 100)%")
        }
    }

    public func build() -> CompiledTemplate {
        return embed(
            ContentBaseTemplate(
                body:

                div.class("row").child(
                    div.class("col-12").child(
                        div.class("page-title-box").child(
                            div.class("page-title-right").child(
                                ol.class("breadcrumb m-0").child(
                                    li.class("breadcrumb-item").child(
                                        a.href("../history").child(
                                            localize(.historyTitle)
                                        )
                                    ),
                                    li.class("breadcrumb-item active").child(
                                        "Øving " + date(\.tasks.first?.date, dateStyle: .short, timeStyle: .short)
                                    )
                                )
                            ),
                            h4.class("page-title").child(
                                variable(\.tasks.first?.date?.dayString)
                            )
                        )
                    )
                ),

                div.class("row").child(
                    div.class("col-12").child(
                        div.class("card").child(
                            div.class("card-body").child(
                                h4.class("header-title mb-4").child(
                                    localize(.histogramTitle)
                                ),
                                div.class("mt-3 chartjs-chart").child(
                                    canvas.id("practice-time-histogram")
                                )
                            )
                        )
                    )
                ),

                div .class("row") .child(
                    div .class("col-12") .child(
                        div .class("card widget-inline") .child(
                            div .class("card-body p-0") .child(
                                div .class("row no-gutters") .child(

                                    embed(
                                        InformationView(icon: "graph-pie", description: localize(.numberOfTasks)),
                                        withPath: \.numberOfTasks
                                    ),
                                    embed(
                                        InformationView(icon: "graph-bar", description: localize(.goal)),
                                        withPath: \.goalProgress
                                    ),
                                    embed(
                                        InformationView(icon: "preview", description: localize(.duration)),
                                        withPath: \.timeUsed
                                    ),
                                    embed(
                                        InformationView(icon: "checkmark", description: localize(.accuracy)),
                                        withPath: \.accuracy
                                    )
                                )
                            )
                        )
                    )
                ),

                div .class("row") .child(
                    div .class("col-12") .child(
                        div .class("card widget-inline") .child(
                            div .class("card-body p-0") .child(
                                div .class("row no-gutters") .child(
                                    div.class("table-responsive").child(
                                        table.class("table table-centered w-100 dt-responsive nowrap").id("products-datatable").child(
                                            thead.class("thead-light").child(
                                                tr.child(
                                                    th.child(
                                                        localize(.topicColumn)
                                                    ),
                                                    th.child(
                                                        localize(.questionColumn)
                                                    ),
                                                    th.child(
                                                        localize(.resultColumn)
                                                    ),
                                                    th.child(
                                                        localize(.resultColumn)
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
                                )
                            )
                        )
                    )
                ),

                scripts: [
                    script.src("/assets/js/vendor/Chart.bundle.min.js"),
                    script.src("/assets/js/practice-session-histogram.js")
                ]
            ),
            withPath: \.base
        )
    }


    // MARK: - Subviews

    struct InformationView: ContextualTemplate {

        struct Context {
            let info: String
        }

        let icon: String
        let description: CompiledTemplate

        func build() -> CompiledTemplate {
            return
                div .class("col-sm-6 col-lg-3") .child(
                    div .class("card shadow-none m-0") .child(
                        div .class("card-body text-center") .child(
                            i .class("dripicons-\(icon) text-muted") .style("font-size: 24px;"),
                            h3 .child(
                                span .child(
                                    variable(\.info)
                                )
                            ),
                            p .class("text-muted font-15 mb-0") .child(
                                description
                            )
                        )
                    )
            )
        }
    }

    struct TaskRow: LocalizedTemplate {

        static var localePath: KeyPath<TaskResultable, String>?

        enum LocalizationKeys: String {
            case days = "result.repeat.days"
        }

        typealias Context = TaskResultable

        func build() -> CompiledTemplate {
            return
                tr.child(
                    td.class("text-muted").child(
                        variable(\.topicName)
                    ),
                    td.class("text-muted").child(
                        variable(\.question)
                    ),
                    td.class("text-muted").child(
                        variable(\.resultDescription)
                    ),
                    td.class("text-muted").child(

                        renderIf(
                            isNotNil: \.revisitDate,

                            div.class("badge float-right")
                                .if(\.revisitTime < 3, add: .class("badge-danger"))
                                .if(\.revisitTime < 11, add: .class("badge-warning"))
                                .if(\.revisitTime > 10, add: .class("badge-success")).child(
                                    localize(.days, with: ["daysUntilRevisit" : variable(\.revisitTime)])
                            )
                        ).else(
                            div.class("badge badge-success float-right").child(
                                "Full kontroll"
                            )
                        )
                    )
            )
        }
    }
}
