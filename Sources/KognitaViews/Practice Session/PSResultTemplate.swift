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
    var topicId: Topic.ID { get }
    var topicName: String { get }
    var question: String { get }
    var revisitTime: Int { get }
    var resultDescription: String { get }
    var resultScore: Double { get }
    var timeUsed: String { get }
    var date: Date? { get }
    var revisitDate: Date? { get }
}

struct TopicResultContext {
    let topicId: Topic.ID
    let topicName: String
    let topicScore: Double
    let tasks: [TaskResultable]
}

struct BreadcrumbItem {
    let link: ViewWrapper?
    let title: ViewWrapper
}

extension PracticeSession.Templates {
    public struct Result: HTMLTemplate {

        public struct Context {
            let locale = "nb"
            let user: User

            let tasks: [TaskResultable]

            let topicResults: [TopicResultContext]

            let progress: Int
            let timeUsed: TimeInterval
            let maxScore: Double
            let achievedScore: Double

            var accuracyScore: Double {
                guard maxScore != 0 else {
                    return 0
                }
                return achievedScore / maxScore
            }

            var singleStats: [SingleStatisticCardContent] {
                [
                    .init(
                        title: "Nåværende nivå",
                        mainContent: accuracyString,
                        extraContent: nil
                    ),
                    .init(
                        title: "Antall oppgaver utført",
                        mainContent: numberOfTasks,
                        extraContent: nil
                    ),
                    .init(
                        title: "Tid øvet",
                        mainContent: timeUsed.timeString,
                        extraContent: nil
                    ),
                ]
            }

            public init(user: User, tasks: [TaskResultable], progress: Int, timeUsed: TimeInterval) {

                var maxScore: Double = 0
                var achievedScore: Double = 0
                for task in tasks {
                    maxScore += 100
                    achievedScore += task.resultScore.clamped(to: 0...100)
                }

                self.user = user
                self.tasks = tasks
                self.progress = progress
                self.timeUsed = timeUsed
                self.maxScore = maxScore
                self.achievedScore = achievedScore

                let grouped = tasks.group(by: \.topicName)
                topicResults = grouped.map { name, tasks in
                    TopicResultContext(
                        topicId: tasks.first?.topicId ?? 0,
                        topicName: name,
                        topicScore: tasks.reduce(0.0) { $0 + $1.resultScore } / Double(tasks.count),
                        tasks: tasks
                    )
                }
                .sorted(by: { $0.topicScore > $1.topicScore })
            }
        }

        public init() {}

        let breadcrumbItems: [BreadcrumbItem] = [.init(link: "../history", title: .init(view: Localized(key: Strings.historyTitle)))]

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Resultat | Øving ", description: "Resultat | Øving "))
            ) {
                PageTitle(
                    title: context.title,
                    breadcrumbs: breadcrumbItems
                )
                Row {
                    Div {
                        Card {
                            H4(Strings.histogramTitle)
                                .class("header-title mb-4")
                            Div {
                                Canvas().id("practice-time-histogram")
                            }.class("mt-3 chartjs-chart")
                        }
                    }.class("col-12")
                }
                Row {
                    Div {
                        IF(context.topicResults.count > 1) {
                            Row {
                                ForEach(in: context.topicResults) { result in
                                    Div {
                                        TopicOverview(
                                            topicId: result.topicId,
                                            topicName: result.topicName,
                                            topicLevel: result.topicScore,
                                            topicTaskResults: result.tasks
                                        )
                                    }
                                    .column(width: .six, for: .medium)
                                }
                            }
                        }
                        .elseIf(context.topicResults.count == 1) {
                            Unwrap(context.topicResults.first) { result in
                                TopicOverview(
                                    topicId: result.topicId,
                                    topicName: result.topicName,
                                    topicLevel: result.topicScore,
                                    topicTaskResults: result.tasks
                                )
                                .isShown(true)
                            }
                        }
                        .else {
                            Text {
                                "Vi klarte ikke å finne noen oppgaver i dette øvingssettet"
                            }
                            .style(.lead)
                        }
                    }
                    .column(width: .eight, for: .large)
                    Div {
                        ForEach(in: context.singleStats) { statistic in
                            SingleStatisticCard(
                                stats: statistic
                            )
                        }
                    }
                    .column(width: .four, for: .large)
                }
            }
            .scripts {
                Script().source("/assets/js/vendor/Chart.bundle.min.js")
                Script().source("/assets/js/practice-session-histogram.js")
            }
        }
    }
}

extension PracticeSession.Templates.Result.Context {
    var numberOfTasks: String { "\(tasks.count)" }
    var goalProgress: String { "\(progress)%" }
    var readableAccuracy: Double { (10000 * accuracyScore).rounded() / 100 }
    var accuracyString: String {
        if readableAccuracy > 90 {
            return "\(readableAccuracy) 🏆"
        } else if readableAccuracy > 70 {
            return "\(readableAccuracy) 🔥"
        } else {
            return "\(readableAccuracy)"
        }
    }
    var date: Date { tasks.first?.date ?? .now }
    var title: String {
        "Øving \(date.formatted(dateStyle: .short, timeStyle: .short))"
    }
}
