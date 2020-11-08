//
//  ExamSession+Result.swift
//  KognitaCore
//
//  Created by Mats Mollestad on 07/11/2020.
//

import Foundation

extension ExamSession.Templates {
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

            var startPracticeSessionCall: String { "startPracticeSessionWithTopicIDs([\(Set(tasks.map { $0.topicID }))], \(subject.id))" }
            var compendiumURI: String { "/subjects/\(subject.id)/compendium" }

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
                self.subject = Subject.Overview(id: result.subject.id, name: result.subject.name, description: result.subject.description, category: result.subject.category, topics: [])
//                self.subject = result.subject

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

        let breadcrumbItems: [BreadcrumbItem] = [.init(link: "/practice-sessions/history", title: .init(view: Localized(key: Strings.historyTitle)))]

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Resultat | Eksamen ", description: "Resultat | Øving ", showCookieMessage: false))
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
                        startSessionCall: context.startPracticeSessionCall,
                        toSubjectURI: context.subject.subjectDetailUri,
                        toCompendiumURI: context.compendiumURI
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

extension ExamSession.Templates.Result.Context {
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
