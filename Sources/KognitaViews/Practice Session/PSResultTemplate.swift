//
//  PSResultTemplate.swift
//  App
//
//  Created by Mats Mollestad on 06/03/2019.
//

import BootstrapKit
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

extension Subject.Overview {
    var subjectDetailUri: String {
        "/subjects/\(id)"
    }
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

extension PracticeSession {
    public enum Templates {}
}

extension Date {
    static var now: Date { Date() }
}

extension Comparable {
    public func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

extension Strideable where Stride: SignedInteger {
    public func clamped(to limits: CountableClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

extension Sequence {

    public func group<P>(by path: KeyPath<Element, P>) -> [P: [Element]] where P: Hashable {
        return Dictionary(grouping: self) { $0[keyPath: path] }
    }

    public func count<T>(equal path: KeyPath<Element, T>) -> [T: Int] where T: Hashable {
        var counts = [T: Int]()
        for object in self {
            let value = object[keyPath: path]
            if let count = counts[value] {
                counts[value] = count + 1
            } else {
                counts[value] = 1
            }
        }
        return counts
    }
}

extension PracticeSession.Templates {
    public struct Result: HTMLTemplate {

        public struct Context {
            let user: User

            let tasks: [TaskResultable]

            let topicResults: [TopicResultContext]

            let timeUsed: TimeInterval
            let maxScore: Double
            let achievedScore: Double

            let subject: Subject.Overview

            var startedAt: Date {
                guard let now = tasks.first?.date else {
                    return .now
                }
                let startedAt = now.addingTimeInterval(-timeUsed)
                return startedAt
            }

            var accuracyScore: Double {
                guard maxScore != 0 else {
                    return 0
                }
                return achievedScore / maxScore
            }

            var timeUsedString: String { return timeUsed.timeString }

            var averageTimePerTaskString: String? {
                guard tasks.isEmpty == false else { return nil }
                let timeUsedPerTask = timeUsed / TimeInterval(tasks.count)
                var timeString = timeUsedPerTask.timeString + " per oppgave"

                if timeUsedPerTask >= 20 {
                    timeString += " 💪"
                } else if timeUsedPerTask >= 10 {
                    timeString += " 🤩"
                } else {
                    timeString += " 🏃‍♂️💨"
                }
                return timeString
            }

            var singleStats: [SingleStatisticCardContent] {
                [
                    .init(
                        title: "Snitt score på øvingen",
                        mainContent: accuracyString,
                        details: nil
                    ),
                    .init(
                        title: "Antall oppgaver utført",
                        mainContent: numberOfTasks,
                        details: nil
                    ),
                    .init(
                        title: "Øvingstid",
                        mainContent: timeUsedString,
                        details: averageTimePerTaskString
                    )
                ]
            }

            public init(user: User, result: Sessions.Result) {

                // FIXME: -- Do it correct

                let tasks = result.results

                var maxScore: Double = 0
                var achievedScore: Double = 0
                for task in tasks {
                    maxScore += 100
                    achievedScore += task.resultScore.clamped(to: 0...100)
                }

                self.user = user
                self.tasks = tasks
                self.timeUsed = tasks.map(\.timeUsed).reduce(0, +)
                self.maxScore = maxScore
                self.achievedScore = achievedScore
                self.subject = Subject.Overview(
                    id: result.subject.id,
                    code: result.subject.code,
                    name: result.subject.name,
                    description: result.subject.description,
                    category: result.subject.category,
                    topics: []
                )

                let grouped = tasks.group(by: \.topicName)
                topicResults = grouped.map { name, tasks in
                    TopicResultContext(
                        topicId: tasks.first?.topicID ?? 0,
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
                baseContext: .constant(.init(title: "Resultat | Øving ", description: "Resultat | Øving ", showCookieMessage: false))
            ) {
                PageTitle(
                    title: context.title,
                    breadcrumbs: breadcrumbItems
                )

                ContentStructure {
                    Row {
                        ForEach(in: context.singleStats) { statistic in
                            Div {
                                SingleStatisticCard(
                                    title: statistic.title,
                                    mainContent: statistic.mainContent,
                                    moreDetails: statistic.details
                                )
                            }.column(width: .six, for: .large)
                        }
                        Div {
                            SingleStatisticCard(
                                title: "Tidspunkt øvingen startet",
                                mainContent: context.startedAt.style(date: .long, time: .short),
                                moreDetails: .constant(nil)
                            )
                        }.column(width: .six, for: .large)
                    }
                }
                .secondary {
                    PractiseSessionResultActionPanel(
                        startSessionCall: context.startPractiseSessionCall,
                        toSubjectURI: context.subject.subjectDetailUri,
                        toCompendiumURI: context.goToCompendium
                    )
                }

                Row {
                    Div {
                        Text { "Temaer" }
                            .style(.heading3)
                    }
                    .column(width: .twelve)
                }
                IF(context.topicResults.count > 1) {
                    Row {
                        ForEach(in: context.topicResults) { result in
                            Div {
                                Sessions.Templates.Result.TopicOverview(
                                    topicId: result.topicId,
                                    topicName: result.topicName,
                                    topicLevel: result.topicScore,
                                    topicTaskResults: result.tasks
                                )
                                .isShown(true)
                            }
                            .column(width: .four, for: .medium)
                        }
                    }
                }
                .elseIf(context.topicResults.count == 1) {
                    Unwrap(context.topicResults.first) { result in
                        Sessions.Templates.Result.TopicOverview(
                            topicId: result.topicId,
                            topicName: result.topicName,
                            topicLevel: result.topicScore,
                            topicTaskResults: result.tasks
                        )
                        .isShown(true)
                    }
                }
                .else {
                    Text { "Vi klarte ikke å finne noen oppgaver i dette øvingssettet" }
                        .style(.lead)
                }
            }
            .scripts {
                Script().source("/assets/js/vendor/Chart.bundle.min.js")
                Script().source("/assets/js/practice-session-histogram.js")
                Script().source("/assets/js/practice-session-create.js")
            }
        }
    }
}

extension PracticeSession.Templates.Result.Context {
    var numberOfTasks: String {
        let taskCount = tasks.count
        var taskCountString = "\(taskCount)"

        if taskCount >= 20 {
            taskCountString += " 🔥"
        } else if taskCount >= 10 {
            taskCountString += " 🤩"
        } else if taskCount >= 5 {
            taskCountString += " 😎"
        }
        return taskCountString
    }
    var readableAccuracy: Double { (10000 * accuracyScore).rounded() / 100 }
    var accuracyString: String {
        var text = "\(readableAccuracy)%"
        if readableAccuracy >= 100 {
            text += " 💯"
        } else if readableAccuracy > 80 {
            text += " 🏆"
        } else if readableAccuracy > 60 {
            text += " 🔥"
        } else if readableAccuracy > 30 {
            text += " 😎"
        }
        return text
    }
    var date: Date { tasks.first?.date ?? .now }
    var title: String {
        "Øving"
    }
}
