////
////  SubjectListTemplate.swift
////  App
////
////  Created by Mats Mollestad on 26/02/2019.
////
//// swiftlint:disable line_length nesting
//
import Foundation
import BootstrapKit
import KognitaCore
//
extension Subject {
    public struct Templates {}
}
//
extension Subject.Templates {
    public struct ListOverview: HTMLTemplate {

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

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Tema liste", description: "Tema liste"))
            ) {

                PageTitle(title: Strings.subjectsTitle.localized())

                IF(context.ongoingSessionPath.isDefined) {
                    Text {
                        "Fortsett"
                    }
                    .style(.heading3)
                    Row {
                        Div {
                            Card {
                                Text {
                                    "Fullfør treningssesjonen"
                                }
                                .style(.heading3)
                                .class("mt-0")
                                Text { "Du har en treningssesjon som ikke er fullført. Sett av litt tid og fullfør." }
                                Anchor {
                                    Button {
                                        Italic().class("mdi mdi-book-open-variant")
                                        " Fortsett"
                                    }
                                    .type(.button)
                                    .class("btn-rounded mb-1")
                                    .button(style: .primary)
                                }
                                .href(context.ongoingSessionPath)
                                .text(color: .dark)
                            }
                            .display(.block)
                        }
                        .class("col-md-6 col-xl-6")
                    }
                }
                H3(Strings.repeatTitle)
                Row {
                    IF(context.revisitTasks.isEmpty) {
                        Div {
                            Card {
                                Text { "Hva kommer her?" }
                                    .style(.heading4)
                                Text {
                                    "Her vil det komme opp temaer som vi anbefaler å prioritere først. Dette skal hjelpe deg med å øve mer effektivt og dermed få mer ut av øvingene dine."
                                }
                                Text {
                                    "Disse anbefalingnene vil først komme når du har gjørt noen oppgaver"
                                }
                            }
                            .display(.block)
                        }
                        .column(width: .twelve)
                    }.else {
                        ForEach(in: context.revisitTasks) { revisit in
                            RevisitCard(context: revisit)
                        }
                    }
                }
                Text(Strings.subjectsListTitle)
                    .style(.heading3)
                Row {
                    IF(context.cards.isEmpty) {
                        Text(Strings.subjectsNoContent)
                            .style(.heading1)
                    }.else {
                        ForEach(in: context.cards) { subject in
                            SubjectCard(subject: subject)
                        }
                    }
                }
            }
            .scripts {
                Script().source("/assets/js/practice-session-create.js")
            }
            .active(path: "/subjects")
        }

        struct RevisitCard<T>: HTMLComponent {

            let context: TemplateValue<T, TopicResultContent>

            var practiceFunction: HTML { "startPracticeSession([" + context.topic.id + "], " + context.subject.id + ");" }

            var body: HTML {
                Div {
                    Card {
                        Badge {
                            Localized(
                                key: Strings.subjectRepeatDays,
                                context: context
                            )
                        }
                        .float(.right)
                        .background(color: .warning)

                        Text {
                            Anchor {
                                context.topic.name
                            }
                            .on(click: practiceFunction)
                            .href("#")
                            .text(color: .dark)
                        }
                        .style(.heading4)
                        .class("mt-0")

                        Text(Strings.subjectRepeatDescription, with: context)
                            .text(color: .muted)
                            .class("font-13 mb-3")

                        Anchor {
                            Button {
                                Italic().class("mdi mdi-book-open-variant")
                                " " +
                                Localized(key: Strings.subjectRepeatStart)
                            }
                            .type(.button)
                            .button(style: .primary)
                            .class("btn-rounded mb-1")
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

        struct SubjectCard<T>: HTMLComponent {

            let subject: TemplateValue<T, Subject>

            var body: HTML {
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
                                Button(Strings.subjectExploreButton)
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
