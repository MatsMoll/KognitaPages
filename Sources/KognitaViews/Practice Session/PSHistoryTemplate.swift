//
//  PSHistoryTemplate.swift
//  App
//
//  Created by Mats Mollestad on 06/03/2019.
//
// swiftlint:disable line_length nesting

import BootstrapKit
import KognitaCore

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
            let subject: Subject
            let sessions: [PracticeSession]
        }

        public struct Context {

            let locale = "nb"
            let user: User
            let sessions: [Sessions]

            public init(user: User, sessions: PracticeSession.HistoryList) {
                self.user = user

                var groups = [Subject.ID: Sessions]()

                for item in sessions.sessions {
                    if let grouped = groups[item.subject.id ?? 0] {
                        groups[item.subject.id ?? 0] = .init(
                            subject: item.subject,
                            sessions: grouped.sessions + [item.session]
                        )
                    } else {
                        groups[item.subject.id ?? 0] = .init(
                            subject: item.subject,
                            sessions: [item.session]
                        )
                    }
                }
                self.sessions = groups.map { $1 }
            }
        }

        public init() {}

        public let context: TemplateValue<Context> = .root()

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
                    IF(context.sessions.count > 1) {
                        ForEach(in: context.sessions) { group in
                            Div {
                                SubjectOverview(
                                    sessions: group
                                )
                            }
                            .column(width: .six)
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
                            "Du har ikke fullført noen øvnger enda. 🤓"
                        }
                        .style(.lead)
                    }
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
                    sessions.subject.name
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
                    ForEach(in: sessions.sessions) { (session: TemplateValue<PracticeSession>) in
                        SessionItem(session: session)
                    }
                }
                .class("list-group list-group-flush")
            }
            .collapseId("collapse".append(html: sessions.subject.id))
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

        let session: TemplateValue<PracticeSession>

        var body: HTML {
            Anchor {

                Button {
                    "Se mer"
                }
                .button(style: .light)
                .float(.right)

                Text {
                    "Startet: "
                    session.createdAt
                        .style(date: .medium, time: .short)
                }
                .text(color: .muted)
                .margin(.three, for: .right)
                .margin(.one, for: .bottom)

                Unwrap(session.timeUsed) { timeUsed in
                    timeUsedText(timeUsed)
                }
            }
            .class("list-group-item")
            .href("/practice-sessions/".append(html: session.id).append(html: "/result"))
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
