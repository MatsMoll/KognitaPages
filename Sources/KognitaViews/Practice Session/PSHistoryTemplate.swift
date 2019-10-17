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
    public struct History: TemplateView {

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

        public var body: View {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Øving's historikk", description: "Øving's historikk")),
                content:
                Row {
                    Div {
                        Div {
                            Div {
                                OrderdList {
                                    ListItem {
                                        "localize(.title)"
                                    }.class("breadcrumb-item")
                                }.class("breadcrumb m-0")
                            }.class("page-title-right")
                        }.class("page-title-box")
                    }.class("col-12")
                } +
                Row {
                    Div {
                        Card {
                            H4 {
                                "localize(.histogramTitle)"
                            }.class("header-title mb-4")
                            Div {
                                Canvas().id("practice-time-histogram")
                            }.class("mt-3 chartjs-chart")
                        }
                    }.class("col-12")
                } +
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
                                                        TableHeader {
                                                            "localize(.dateColumn)"
                                                        }
                                                        TableHeader {
                                                            "localize(.goalColumn)"
                                                        }
                                                        TableHeader {
                                                            "localize(.durationColumn)"
                                                        }
                                                    }
                                                }
                                                .class("thead-light")

                                                TableBody {
                                                    ForEach(in: context.sessions) { (session: RootValue<PracticeSession>) in
                                                        TableRow {
                                                            TableCell {
                                                                Anchor {
                                                                    session.createdAt
                                                                        .style(dateStyle: .medium, timeStyle: .short)
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
                                            .class("table table-centered w-100 dt-responsive nowrap")
                                        }
                                        .class("table-responsive")
                                    }
                                    .noGutters()
                                }.else {
                                    Div {
                                        H3 {
                                            "localize(.noSessions)"
                                        }
                                    }
                                    .column(width: .twelve)
                                }
                            }.class("card-body p-0")
                        }.class("card widget-inline")
                    }.class("col-12")
                },

                scripts: [
                    Script().source("/assets/js/vendor/Chart.bundle.min.js"),
                    Script().source("/assets/js/practice-session-histogram.js")
                ]
            )
        }
    }
}

//public struct PSHistoryTemplate: LocalizedTemplate {
//
//    public init() {}
//
//    public static var localePath: KeyPath<PSHistoryTemplate.Context, String>? = \.locale
//
//    public enum LocalizationKeys: String {
//        case title = "history.title"
//        case histogramTitle = "history.histogram.title"
//        case dateColumn = "history.summary.date"
//        case goalColumn = "history.summary.goal"
//        case durationColumn = "history.summary.duration"
//        case noSessions = "history.summary.none"
//    }
//
//    public struct Context {
//        let locale = "nb"
//        let base: ContentBaseTemplate.Context
//        let sessions: [PracticeSession]
//
//        public init(user: User, sessions: [PracticeSession]) {
//            self.base = .init(user: user, title: "Øving's historikk")
//            self.sessions = sessions
//        }
//    }
//
//    public func build() -> CompiledTemplate {
//        return embed(
//            ContentBaseTemplate(
//
//                body:
//                div.class("row").child(
//                    div.class("col-12").child(
//                        div.class("page-title-box").child(
//                            div.class("page-title-right").child(
//                                ol.class("breadcrumb m-0").child(
//                                    li.class("breadcrumb-item").child(
//                                        localize(.title)
//                                    )
//                                )
//                            )
//                        )
//                    )
//                ),
//
//                div.class("row").child(
//                    div.class("col-12").child(
//                        div.class("card").child(
//                            div.class("card-body").child(
//                                h4.class("header-title mb-4").child(
//                                    localize(.histogramTitle)
//                                ),
//                                div.class("mt-3 chartjs-chart").child(
//                                    canvas.id("practice-time-histogram")
//                                )
//                            )
//                        )
//                    )
//                ),
//
//                div .class("row") .child(
//                    div .class("col-12") .child(
//                        div .class("card widget-inline") .child(
//                            div .class("card-body p-0") .child(
//
//                                renderIf(
//                                    \.sessions.count > 0,
//
//                                    div .class("row no-gutters") .child(
//                                        div.class("table-responsive").child(
//                                            table.class("table table-centered w-100 dt-responsive nowrap").id("products-datatable").child(
//                                                thead.class("thead-light").child(
//                                                    tr.child(
//                                                        th.child(
//                                                            localize(.dateColumn)
//                                                        ),
//                                                        th.child(
//                                                            localize(.goalColumn)
//                                                        ),
//                                                        th.child(
//                                                            localize(.durationColumn)
//                                                        )
//                                                    )
//                                                ),
//                                                tbody.child(
//                                                    forEach(
//                                                        in:     \.sessions,
//                                                        render: SessionRow()
//                                                    )
//                                                )
//                                            )
//                                        )
//                                    )
//                                ).else(
//                                    div.class("col-12").child(
//                                        h3.child(
//                                            localize(.noSessions)
//                                        )
//                                    )
//                                )
//                            )
//                        )
//                    )
//                ),
//
//                scripts: [
//                    script.src("/assets/js/vendor/Chart.bundle.min.js"),
//                    script.src("/assets/js/practice-session-histogram.js")
//                ]
//            ),
//            withPath: \.base
//        )
//    }
//
//    // Subviews
//
//    struct SessionRow: ContextualTemplate {
//
//        typealias Context = PracticeSession
//
//        func build() -> CompiledTemplate {
//            return
//                tr.child(
//                    td.child(
//                        a.href("/practice-sessions/", variable(\.id), "/result").class("text-muted").child(
//                            date(\.createdAt, dateStyle: .medium, timeStyle: .short)
//                        )
//                    ),
//                    td.child(
//                        a.href("/practice-sessions/", variable(\.id), "/result").class("text-muted").child(
//                            variable(\.numberOfTaskGoal), " oppgaver"
//                        )
//                    ),
//                    td.child(
//                        a.href("/practice-sessions/", variable(\.id), "/result").class("text-muted").child(
//
//                            renderIf(
//                                isNotNil: \.timeUsed,
//
//                                variable(\.timeUsed?.timeString)
//                            ).else(
//                                div.class("badge badge-danger").child(
//                                    "Ikke helt fullført"
//                                )
//                            )
//                        )
//                    )
//            )
//        }
//    }
//}
//
//extension Date {
//
//    var dayTimeString: String {
//        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: "nb")
//        formatter.dateFormat = "d MMM HH:mm"
//        return formatter.string(from: self)
//    }
//
//    var dayString: String {
//        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: "nb")
//        formatter.dateStyle = .medium
//        return formatter.string(from: self)
//    }
//}
