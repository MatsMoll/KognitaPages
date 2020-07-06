import BootstrapKit
import Foundation

extension Sessions {
    public enum Templates {}
}

public protocol SessionRepresentable: Codable {

    var subjectName: String { get }
    var title: String { get }
    var sessionUri: String { get }
    var executionDate: Date { get }
    var duration: TimeInterval { get }
    var isTest: Bool { get }
}

extension PracticeSession.Overview: SessionRepresentable {

    public var title: String { "Øving i \(subjectName)" }
    public var sessionUri: String { "/practice-sessions/\(id)/result" }
    public var executionDate: Date { createdAt }
    public var duration: TimeInterval { endedAt.timeIntervalSince(executionDate) }
    public var isTest: Bool { false }
}

extension TestSession.CompletedOverview: SessionRepresentable {
    public var title: String { self.testTitle }

    public var sessionUri: String { "/test-sessions/\(id)/results" }

    public var executionDate: Date { self.createdAt }

    public var duration: TimeInterval { self.endedAt.timeIntervalSince(executionDate) }
    public var isTest: Bool { true }
}

extension Sessions.Templates {
    struct Histogram: HTMLComponent, AttributeNode {

        var scripts: HTML { Script(source: "/assets/js/practice-session-histogram.js") }

        var attributes: [HTMLAttribute] = []

        var body: HTML {
            Card {
                Text(Strings.histogramTitle)
                    .class("header-title mb-4")
                Div {
                    Canvas().id("practice-time-histogram")
                }
                .class("mt-3 chartjs-chart")
            }
            .add(attributes: attributes)
        }

        func copy(with attributes: [HTMLAttribute]) -> Sessions.Templates.Histogram {
            .init(attributes: attributes)
        }
    }

    public struct History: HTMLTemplate {

        public struct Context {
            let user: User
            let sessions: [SessionRepresentable]

            var timeUsed: Double { sessions.reduce(0) { $0 + $1.duration } }
            var totalTimeString: String {
                if timeUsed > 86_400 {
                    return timeUsed.timeString + " 🔥"
                } else if timeUsed > 600 {
                    return timeUsed.timeString + " 😎"
                } else {
                    return timeUsed.timeString
                }
            }

            var numberOfSessionString: String {
                let numberOfSessions = sessions.count

                if numberOfSessions > 100 {
                    return "\(numberOfSessions) 💯"
                } else if numberOfSessions > 30 {
                    return "\(numberOfSessions) 🔥"
                } else if numberOfSessions > 10 {
                    return "\(numberOfSessions) 😎"
                } else {
                    return "\(numberOfSessions)"
                }
            }

            public init(user: User, sessions: Sessions.HistoryList) {
                var sessionRepresentables: [SessionRepresentable] = []
                sessionRepresentables.append(contentsOf: sessions.practiceSessions)
                sessionRepresentables.append(contentsOf: sessions.testSessions)
                self.sessions = sessionRepresentables.sorted(by: { $0.executionDate > $1.executionDate })
                self.user = user
            }
        }

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "History", description: "History"))
            ) {
                PageTitle(Strings.historyTitle)

                Row {
                    Div { Histogram() }
                        .column(width: .eight, for: .large)

                    Div {
                        Card {
                            Text { "Antall aktiviteter" }
                                .text(color: .muted)

                            Text { context.numberOfSessionString }
                                .text(color: .dark)
                                .style(.lead)
                                .font(style: .bold)
                        }

                        Card {
                            Text { "Total tid" }
                                .text(color: .muted)

                            Text { context.totalTimeString }
                                .text(color: .dark)
                                .style(.lead)
                                .font(style: .bold)
                        }
                    }
                    .column(width: .four, for: .large)
                }
                Row {
                    SessionSection(sessions: context.sessions)
                }
            }
            .scripts {
                Script().source("/assets/js/vendor/Chart.bundle.min.js")
            }
        }
    }
}

extension Sessions.Templates.History {

    struct SessionSection: HTMLComponent {

        let sessions: TemplateValue<[SessionRepresentable]>

        var body: HTML {
            Div {
                Text { "Aktiviteter" }
                    .style(.heading3)

                IF(sessions.count > 1) {
                    ForEach(in: sessions) { session in
                        SessionCard(session: session)
                    }
                }
                .else {
                    Text {
                        "Du har ikke fullført noen øvinger ennå. Gå inn på et fag for å starte! 🔥"
                    }
                    .style(.lead)
                }
            }
            .column(width: .twelve)
        }
    }

    struct SessionCard: HTMLComponent {

        let session: TemplateValue<SessionRepresentable>

        var body: HTML {
            Card {
                Anchor { "Se mer" }
                    .href(session.sessionUri)
                    .button(style: .light)
                    .float(.right)

                IF(session.isTest) {
                    Badge { "Prøve" }
                        .background(color: .success)
                        .margin(.two, for: .bottom)
                }

                Text { session.subjectName }

                Text { session.title }
                    .style(.heading4)

                Text {
                    "Startet: "
                    session.executionDate
                        .style(date: .medium, time: .short)
                }
                .text(color: .muted)
                .margin(.three, for: .right)
                .margin(.one, for: .bottom)
            }
        }
    }

    struct SearchCard: HTMLComponent {

        var body: HTML {
            Card {
                Text { "Søk" }
                Form {
                    InputGroup {
                        Input()
                            .type(.text)
                            .placeholder("Søk..")
                            .id("title")
                            .name("taskQuestion")
                    }
                    .append {
                        Button {
                            "Søk"
                        }
                        .button(style: .primary)
                        .type(.submit)
                    }
                    .margin(.three, for: .bottom)
                }
            }
        }
    }
}
