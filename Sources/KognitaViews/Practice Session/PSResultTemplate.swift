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

public struct Divider: DatableNode {
    
    public var attributes: [HTMLAttribute]
    
    public var name: String { "hr" }
    
    public init(attributes: [HTMLAttribute] = []) {
        self.attributes = attributes
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
            
            var singleStats: [SingleStatisticCardContent] {
                [
                    .init(
                        title: "Snitt score på øvingen",
                        mainContent: accuracyString
                    ),
                    .init(
                        title: "Antall oppgaver utført",
                        mainContent: numberOfTasks
                    ),
                    .init(
                        title: "Øvingstid",
                        mainContent: timeUsed.timeString
                    ),
                ]
            }
            
            public init(user: User, result: PracticeSession.Result) {
                
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
                self.subject = result.subject
                
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
                baseContext: .constant(.init(title: "Resultat | Øving ", description: "Resultat | Øving "))
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
                                    mainContent: statistic.mainContent
                                )
                            }.column(width: .six, for: .large)
                        }
                        Div {
                            SingleStatisticCard(
                                title: "Tidspunkt øvingen startet",
                                mainContent: context.startedAt.style(date: .long, time: .short)
                            )
                        }.column(width: .six, for: .large)
                    }
                }
                .secondary {
                    Card {
                        H4(Strings.histogramTitle)
                            .class("header-title mb-4")
                        Div {
                            Canvas().id("practice-time-histogram")
                        }.class("mt-3 chartjs-chart")
                    }
                    
                    
                }
                
                //                Div {
                //                    Divider()
                //                }
                //                .column(width: .twelve)
                
                Text { "Handlinger" }
                    .style(.heading3)
                
                Row {
                    Div {
                        Row {
                            Div {
                                Card {
                                    Text {
                                        "Vil du øve mer på dette?"
                                    }
                                    .style(.cardTitle)
                                    
                                    Button {
                                        "Start ny øving"
                                    }
                                    .isRounded()
                                    .on(click: context.startPractiseSessionCall)
                                    .button(style: .primary)
                                }
                            }
                            .column(width: .four, for: .large)
                                //                        .margin(.zero, for: .vertical, sizeClass: .large)
                                //                        .margin(.three, for: .vertical)
//                                .class("text-center")
                            
                            Div {
                                Card {
                                    Text {
                                        "Vil du gjøre noe annet i emnet?"
                                    }
                                    .style(.cardTitle)
                                    
                                    Anchor {
                                        "Gå tilbake til faget"
                                    }
                                    .isRounded()
                                    .href(context.subject.subjectDetailUri)
                                    .button(style: .light)
                                }
                            }
                            .column(width: .four, for: .large)
                                //                        .margin(.zero, for: .vertical, sizeClass: .large)
                                //                        .margin(.three, for: .vertical)
//                                .class("text-center")
                            
                            Div {
                                Card {
                                    Text {
                                        "Trenger du lesestoff?"
                                    }
                                    .style(.cardTitle)
                                    
                                    Anchor {
                                        "Gå til kompendiumet"
                                    }
                                    .isRounded()
                                    .href(context.subject.subjectDetailUri)
                                    .button(style: .light)
                                }
                            }
                            .column(width: .four, for: .large)
                                //                        .margin(.zero, for: .vertical, sizeClass: .large)
                                //                        .margin(.three, for: .vertical)
//                                .class("text-center")
                        }
                        
                    }
                    .column(width: .twelve)
                    
                }
                //                .class("text-center")
                
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
                                TopicOverview(
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
    var numberOfTasks: String { "\(tasks.count)" }
    var readableAccuracy: Double { (10000 * accuracyScore).rounded() / 100 }
    var accuracyString: String {
        var text = "\(readableAccuracy)%"
        if readableAccuracy > 90 {
            text += " 🏆"
        } else if readableAccuracy > 70 {
            text += " 🔥"
        }
        return text
    }
    var date: Date { tasks.first?.date ?? .now }
    var title: String {
        "Øving"
    }
    var startPractiseSessionCall: String {
        "startPracticeSessionWithTopicIDs(\(topicResults.map(\.topicId)), \(subject.id))"
    }
}
