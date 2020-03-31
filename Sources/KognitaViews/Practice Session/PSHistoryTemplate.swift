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

public protocol SessionRepresentable: Codable {

    var title: String { get }
    var sessionUri: String { get }
    var executionDate: Date { get }
}

extension PracticeSession.HighOverview: SessionRepresentable {

    public var title: String {
        return "Øving"
    }

    public var sessionUri: String {
        "/practice-sessions/\(id)/result"
    }

    public var executionDate: Date {
        createdAt
    }
}

extension TestSession.HighOverview: SessionRepresentable {

    public var title: String { testTitle }

    public var sessionUri: String { "/test-sessions/\(id)/results" }

    public var executionDate: Date { createdAt }
}


extension HTML {
    func append(html: HTML) -> HTML {
        var output: Array<HTML> = []

        if let list = self as? Array<HTML> {
            output.append(contentsOf: list)
        } else {
            output.append(self)
        }

        if let list = html as? Array<HTML> {
            output.append(list)
        } else {
            output.append(html)
        }
        return output
    }
}

extension PracticeSession {
    public struct Templates {}
}

extension PracticeSession.Templates {

    public struct History: HTMLTemplate {

        struct Sessions {
            let subjectName: String
            let subjectID: Subject.ID
            let sessions: [SessionRepresentable]
        }

        public struct Context {

            let locale = "nb"
            let user: User
            let sessions: [Sessions]

            public init(user: User, sessions: TaskSession.HistoryList) {
                self.user = user

                var groups = [Subject.ID: Sessions]()

                for item in sessions.practiceSessions {
                    if let grouped = groups[item.subjectID] {
                        groups[item.subjectID] = .init(
                            subjectName: item.subjectName,
                            subjectID: item.subjectID,
                            sessions: grouped.sessions + [item]
                        )
                    } else {
                        groups[item.subjectID] = .init(
                            subjectName: item.subjectName,
                            subjectID: item.subjectID,
                            sessions: [item]
                        )
                    }
                }
                for item in sessions.testSessions {
                    if let grouped = groups[item.subjectID] {
                        groups[item.subjectID] = .init(
                            subjectName: item.subjectName,
                            subjectID: item.subjectID,
                            sessions: grouped.sessions + [item]
                        )
                    } else {
                        groups[item.subjectID] = .init(
                            subjectName: item.subjectName,
                            subjectID: item.subjectID,
                            sessions: [item]
                        )
                    }
                }
                self.sessions = groups.map { $1 }
            }
        }

        public init() {}

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Øvingshistorikk", description: "Øvingshistorikk"))
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
                    IF(context.sessions.count > 1) {
                        ForEach(in: context.sessions) { group in
                            Div {
                                SubjectOverview(
                                    sessions: group
                                )
                            }
                            .column(width: .six, for: .large)
                            .column(width: .twelve)
                        }
                    }
                    .elseIf(context.sessions.count == 1) {
                        Unwrap(context.sessions.first) { group in
                            Div {
                                SubjectOverview(
                                    sessions: group
                                )
                                    .isShown(true)
                            }
                            .column(width: .twelve)
                        }
                    }
                    .else {
                        Text {
                            "Du har ikke fullført noen øvinger enda. 🤓"
                        }
                        .style(.lead)
                    }
                }
            }
            .scripts {
                Script().source("/assets/js/vendor/Chart.bundle.min.js")
                Script().source("/assets/js/practice-session-histogram.js")
            }
            .active(path: "/practice-sessions/history")
        }
    }
}


extension PracticeSession.Templates.History {

    struct SubjectOverview: HTMLComponent, AttributeNode {

        let sessions: TemplateValue<Sessions>

        init(sessions: TemplateValue<Sessions>) {
            self.sessions = sessions
        }

        init(sessions: TemplateValue<Sessions>, isShownValue: Conditionable, attributes: [HTMLAttribute]) {
            self.sessions = sessions
            self.isShownValue = isShownValue
            self.attributes = attributes
        }

        private var isShownValue: Conditionable = false
        var attributes: [HTMLAttribute] = []

        var body: HTML {
            CollapsingCard {
                Text {
                    sessions.subjectName
                }
                .style(.heading3)
                .text(color: .secondary)
                .margin(.zero, for: .top)

                Text {
                    sessions.sessions.count
                    " Øvinger"
                }
                .text(color: .secondary)
            }
            .content {
                Div {
                    ForEach(in: sessions.sessions) { (session: TemplateValue<SessionRepresentable>) in
                        SessionItem(session: session)
                    }

                }
                .class("list-group list-group-flush")
            }
            .collapseId("collapse".append(html: sessions.subjectID))
            .isShown(isShownValue)
            .add(attributes: attributes)
        }

        func copy(with attributes: [HTMLAttribute]) -> PracticeSession.Templates.History.SubjectOverview {
            .init(sessions: sessions, isShownValue: isShownValue, attributes: attributes)
        }

        func isShown(_ condition: Conditionable) -> PracticeSession.Templates.History.SubjectOverview {
            .init(sessions: sessions, isShownValue: condition, attributes: attributes)
        }
    }

    struct SessionItem: HTMLComponent {

        let session: TemplateValue<SessionRepresentable>

        var body: HTML {
            Anchor {

                Button {
                    "Se mer"
                }
                .button(style: .light)
                .float(.right)

                Text {
                    session.title
                }
                .margin(.three, for: .right)
                .margin(.one, for: .bottom)
                .style(.heading4)
                .text(color: .dark)

                Text {
                    "Startet: "
                    session.executionDate
                        .style(date: .medium, time: .short)
                }
                .text(color: .muted)
                .margin(.three, for: .right)
                .margin(.one, for: .bottom)
            }
            .class("list-group-item")
            .href(session.sessionUri)
        }

        func timeUsedText(_ timeUsed: TemplateValue<Double>) -> HTML {
            Text {
                "Lengde: "
                timeUsed.timeString
            }
            .text(color: .muted)
            .margin(.three, for: .right)
            .margin(.one, for: .bottom)
        }
    }
}
