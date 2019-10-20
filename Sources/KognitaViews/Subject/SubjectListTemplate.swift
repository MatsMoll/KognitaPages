//
//  SubjectListTemplate.swift
//  App
//
//  Created by Mats Mollestad on 26/02/2019.
//
// swiftlint:disable line_length nesting

import Foundation
import BootstrapKit
import KognitaCore

extension Subject {
    public struct Templates {}
}

extension Subject.Templates {
    public struct ListOverview: TemplateView {

        public struct Context {
            let user: User
            let cards: [Subject]
            let revisitTasks: [TopicResultContent]
            let ongoingSessionPath: String?

            public init(user: User, cards: [Subject], revisitTasks: [TopicResultContent], ongoingSessionPath: String?) {
                self.user = user
                self.cards = cards
                self.revisitTasks = revisitTasks
                self.ongoingSessionPath = ongoingSessionPath
            }
        }

        public init() {}

        public let context: RootValue<Context> = .root()

        public var body: View {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Tema liste", description: "Tema liste")),
                content:

                PageTitle(title: "localize(.title)") +

                IF(context.ongoingSessionPath.isDefined) {
                    H3 {
                        "Fortsett"
                    }
                    Div {
                        Div {
                            Div {
                                Div {
                                    H3 {
                                        "Fullfør treningssesjonen"
                                    }.class("mt-0")
                                    P {
                                        "Du har en treningssesjon som ikke er fullført. Sett av litt tid og fullfør."
                                    }
                                    Anchor {
                                        Button {
                                            Italic().class("mdi mdi-book-open-variant")
                                            " Fortsett"
                                        }.type("button").class("btn btn-primary btn-rounded mb-1")
                                    }.href(context.ongoingSessionPath).class("text-dark")
                                }.class("card-body")
                            }.class("card d-block")
                        }.class("col-md-6 col-xl-6")
                    }.class("row")
                } +
                H3 { "localize(.repeatTitle)" } +
                Row {
                    IF(context.revisitTasks.isEmpty) {
                        Div {
                            Div {
                                Div {
                                    H4 {
                                        "Hva kommer her?"
                                    }
                                    P {
                                        "Her vil det komme opp temaer som vi anbefaler å prioritere først. Dette skal hjelpe deg med å øve mer effektivt og dermed få mer ut av øvingene dine."
                                    }
                                    P {
                                        "Disse anbefalingnene vil først komme når du har gjørt noen oppgaver"
                                    }
                                }.class("card-body")
                            }.class("card d-block")
                        }.class("col-12")
                    }.else {
                        ForEach(in: context.revisitTasks) { revisit in
                            RevisitCard(context: revisit)
                        }
                    }
                } +

                H3 {
                    "localize(.listTitle)"
                } +
                IF(context.cards.isEmpty) {
                    Div {
                        H1 {
                            "localize(.noContent)"
                        }
                    }.class("row")
                }.else {
                    ForEach(in: context.cards) { subject in
                        SubjectCard(subject: subject)
                    }
                },

                scripts: [
                    Script().source("/assets/js/practice-session-create.js")
                ]
            )
        }

        struct RevisitCard<T>: StaticView {

            let context: TemplateValue<T, TopicResultContent>

            var practiceFunction: View { "startPracticeSession(" + context.topic.id + ", " + context.subject.id + ");" }

            var body: View {
                Div {
                    Card {
                        Div {
                            "localize(.days)"
                        }
                        .class("badge float-right")
                        H3 {
                            Anchor {
                                context.topic.name
                            }
                            .on(click: practiceFunction)
                            .href("#")
                            .text(color: .dark)
                        }
                        .class("mt-0")
                        P {
                            "localize(.repeatDescription)"
                        }
                        .class("text-muted font-13 mb-3")
                        Anchor {
                            Button {
                                Italic().class("mdi mdi-book-open-variant")
                                " " + "localize(.start)"
                            }
                            .type(.button)
                            .class("btn btn-primary btn-rounded mb-1")
                        }
                        .on(click: practiceFunction)
                        .href("#")
                        .text(color: .dark)
                    }
                    .display(.block)
                }
                .class("col-md-6 col-lg-4")
            }
        }

        struct SubjectCard<T>: StaticView {

            let subject: TemplateValue<T, Subject>

            var body: View {
                Div {
                    Anchor {
                        Div {
                            Div {
                                H3 {
                                    subject.name
                                }
                                Badge {
                                    subject.category
                                }
                                .background(color: .light)
                            }
                            .class("card-header bg-" + subject.colorClass.rawValue)
                            .text(color: .white)
                            Div {
                                P {
                                    subject.description
                                        .escaping(.unsafeNone)
                                }
                                Button {
                                    "localize(.button)"
                                }
                                .class("btn btn-" + subject.colorClass.rawValue + " btn-rounded")
                            }
                            .class("card-body position-relative")
                        }
                        .class("card")
                        .display(.block)
                    }
                    .href("subjects/" + subject.id)
                    .text(color: .dark)
                }
                .class("col-md-6 col-xl-6")
            }
        }
    }
}
