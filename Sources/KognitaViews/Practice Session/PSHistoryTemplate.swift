//
//  PSHistoryTemplate.swift
//  App
//
//  Created by Mats Mollestad on 06/03/2019.
//
// swiftlint:disable line_length nesting

import BootstrapKit
import KognitaCore
import Foundation

extension PracticeSession {
    public struct Templates {}
}

extension PracticeSession.Templates {
    public struct History: HTMLTemplate {

        public struct Context {
            let locale = "nb"
            let user: User
            let sessions: [PracticeSession]

            public init(user: User, sessions: [PracticeSession]) {
                self.user = user
//                self.base = .init(user: user, title: "Øving's historikk")
                self.sessions = sessions
            }
        }

        public init() {}

        public let context: RootValue<Context> = .root()

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Øving's historikk", description: "Øving's historikk"))
            ) {

                PageTitle(Strings.historyTitle)
                Row {
                    Div {
                        Card {
                            Text(Strings.histogramTitle)
                                .class("header-title mb-4")
                            Div {
                                Canvas().id("practice-time-histogram")
                            }
                            .class("mt-3 chartjs-chart")
                        }
                    }
                    .class("col-12")
                }
                Row {
                    Div {
                        Div {
                            Div {
                                IF(context.sessions.count > 0) {
                                    Row {
                                        Div {
                                            Table {
                                                TableHead {
                                                    TableRow {
                                                        TableHeader(Strings.historyDateColumn)
                                                        TableHeader(Strings.historyGoalColumn)
                                                        TableHeader(Strings.historyDurationColumn)
                                                    }
                                                }
                                                .class("thead-light")

                                                TableBody {
                                                    PracticeSessionRows(
                                                        sessions: context.sessions
                                                    )
                                                }
                                            }
                                            .class("table table-centered w-100 dt-responsive nowrap")
                                        }
                                        .class("table-responsive")
                                    }
                                    .noGutters()
                                }.else {
                                    Div {
                                        Text(Strings.historyNoSessions)
                                            .style(.heading3)
                                    }
                                    .column(width: .twelve)
                                }
                            }.class("card-body p-0")
                        }.class("card widget-inline")
                    }.class("col-12")
                }
                .enviroment(locale: "nb")
            }
            .scripts {
                Script().source("/assets/js/vendor/Chart.bundle.min.js")
                Script().source("/assets/js/practice-session-histogram.js")
            }
            .active(path: "/practice-sessions/history")
        }
    }

    struct PracticeSessionRows<T>: HTMLComponent {

        let sessions: TemplateValue<T, [PracticeSession]>

        var body: HTML {
            ForEach(in: sessions) { (session: RootValue<PracticeSession>) in
                TableRow {
                    TableCell {
                        Anchor {
                            session.createdAt
                                .style(date: .medium, time: .short)
                        }
                        .href("/practice-sessions/" + session.id + "/result")
                        .class("text-muted")
                    }
                    TableCell {
                        Anchor {
                            session.numberOfTaskGoal
                            " oppgaver"
                        }
                        .href("/practice-sessions/" + session.id + "/result")
                        .class("text-muted")
                    }
                    TableCell {
                        Anchor {
                            IF(session.timeUsed.isDefined) {
                                session.timeUsed.unsafelyUnwrapped.timeString
                            }.else {
                                Badge {
                                    "Ikke helt fullført"
                                }
                                .background(color: .danger)
                            }
                        }
                        .href("/practice-sessions/" + session.id + "/result")
                        .class("text-muted")
                    }
                }

            }
        }
    }
}
