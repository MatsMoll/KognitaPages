//
//  PSResultTemplate.swift
//  App
//
//  Created by Mats Mollestad on 06/03/2019.
//
// swiftlint:disable line_length nesting

import BootstrapKit
import KognitaCore
import Foundation

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

struct ViewWrapper: View {
    let view: View

    func render<T>(with manager: HTMLRenderer.ContextManager<T>) throws -> String {
        try view.render(with: manager)
    }

    func prerender<T>(_ formula: HTMLRenderer.Formula<T>) throws {
        try view.prerender(formula)
    }
}

struct BreadcrumbItem {
    let link: String?
    let title: ViewWrapper
}

extension ViewWrapper: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self.view = value
    }
}

extension PracticeSession.Templates {
    public struct Result: TemplateView {

        public struct Context {
            let locale = "nb"
            let user: User

            let numberOfTasks: String
            let goalProgress: String
            let timeUsed: String
            let accuracy: String

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

                self.user = user
//                title: "Resultat | Øving ")
                self.tasks = tasks
                self.numberOfTasks = "\(tasks.count)"
                self.goalProgress = "\(progress)%"
                self.timeUsed = timeUsed.timeString
                self.accuracy = "\((10000 * accuracyScore).rounded() / 100)%"
            }
        }

        public init() {}

        public let context: RootValue<Context> = .root()

        let breadcrumbItems: [BreadcrumbItem] = [.init(link: "../history", title: .init(view: Localized(key: LocalizationKeys.historyTitle)))]

        public var body: View {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Resultat | Øving ", description: "Resultat | Øving "))
            ) {
                PageTitle(
                    title: "Øving " + context.goalProgress,
                    breadcrumbs: breadcrumbItems
                )
                Row {
                    Div {
                        Card {
                            H4(LocalizationKeys.histogramTitle)
                                .class("header-title mb-4")
                            Div {
                                Canvas().id("practice-time-histogram")
                            }.class("mt-3 chartjs-chart")
                        }
                    }.class("col-12")
                }
                Row {
                    Div {
                        Div {
                            Div {
                                Row {
                                    StatsView(
                                        stats: context.numberOfTasks,
                                        icon: "graph-pie",
                                        description: LocalizationKeys.resultSummaryNumberOfTasks
                                    )
                                    StatsView(
                                        stats: context.goalProgress,
                                        icon: "graph-bar",
                                        description: LocalizationKeys.resultSummaryGoal
                                    )
                                    StatsView(
                                        stats: context.timeUsed,
                                        icon: "preview",
                                        description: LocalizationKeys.resultSummaryDuration
                                    )
                                    StatsView(
                                        stats: context.accuracy,
                                        icon: "checkmark",
                                        description: LocalizationKeys.resultSummaryAccuracy
                                    )
                                }
                                .noGutters()
                            }.class("card-body p-0")
                        }.class("card widget-inline")
                    }.class("col-12")
                }
                Row {
                    Div {
                        Div {
                            Div {
                                Div {
                                    Div {
                                        Table {
                                            TableHead {
                                                TableRow {
                                                    TableHeader(LocalizationKeys.resultSummaryTopicColumn)
                                                    TableHeader(LocalizationKeys.resultSummaryQuestionColumn)
                                                    TableHeader(LocalizationKeys.resultSummaryResultColumn)
                                                    TableHeader(LocalizationKeys.resultSummaryRepeatColumn)
                                                }
                                            }.class("thead-light")
                                            TableBody {
                                                ForEach(in: context.tasks) { result in
                                                    TableRow {
                                                        TableCell {
                                                            result.topicName
                                                        }
                                                        .text(color: .muted)

                                                        TableCell {
                                                            result.question
                                                        }
                                                        .text(color: .muted)

                                                        TableCell {
                                                            result.resultDescription
                                                        }
                                                        .text(color: .muted)

                                                        TableCell {
                                                            IF(result.revisitDate.isDefined) {
                                                                Div {
                                                                    "localize(.days)"
                                                                    result.revisitTime
                                                                }
                                                                .class("badge float-right")
                                                            }.else {
                                                                Div {
                                                                    "Full kontroll"
                                                                }
                                                                .class("badge badge-success float-right")
                                                            }
                                                        }
                                                        .text(color: .muted)
                                                    }
                                                }
                                            }
                                        }.class("table table-centered w-100 dt-responsive nowrap").id("products-datatable")
                                    }.class("table-responsive")
                                }.class("row no-gutters")
                            }.class("card-body p-0")
                        }.class("card widget-inline")
                    }.class("col-12")
                }
            }
            .scripts {
                Script().source("/assets/js/vendor/Chart.bundle.min.js")
                Script().source("/assets/js/practice-session-histogram.js")
            }
        }

        struct StatsView<T>: StaticView {

            let stats: TemplateValue<T, String>
            let icon: String
            let description: String

            var body: View {
                Div {
                    Div {
                        Div {
                            Italic()
                                .class("dripicons-\(icon) text-muted")
                                .style(css: "font-size: 24px;")
                            H3 {
                                Span {
                                    stats
                                }
                            }
                            Text(description)
                                .class("text-muted font-15 mb-0")
                        }
                        .class("card-body text-center")
                    }
                    .class("card shadow-none m-0")
                }
                .class("col-sm-6 col-lg-3")
            }
        }
    }
}
