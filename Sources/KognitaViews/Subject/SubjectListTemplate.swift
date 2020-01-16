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
            let list: Subject.ListContent

            public init(user: User, list: Subject.ListContent) {
                self.user = user
                self.list = list
            }
        }

        public init() {}

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Tema liste", description: "Tema liste"))
            ) {

                PageTitle(title: Strings.subjectsTitle.localized())

                Row {
                    Div {
                        SubjectTestList(test: context.list.openedTest)

//                        ContinuePracticeSessionCard(
//                            ongoingSessionPath: context.
//                        )
                        SubjectListSection(subjects: context.list.subjects)
                    }
                    .column(width: .eight, for: .large)
                    Div {
                        StatisticsCard()
                        IF(context.user.isAdmin) {
                            CreateContentCard()
                        }
                    }
                    .column(width: .four, for: .large)
                }
            }
            .scripts {
                Script().source("/assets/js/practice-session-create.js")
                Script().source("/assets/js/vendor/Chart.bundle.min.js")
                Script().source("/assets/js/practice-session-histogram.js")
            }
            .active(path: "/subjects")
            .modals {
                Unwrap(context.list.openedTest) { test in
                    SubjectTest.Templates.StartModal(test: test)
                }
            }
        }

        struct SubjectListSection: HTMLComponent {

            @TemplateValue([Subject].self)
            var subjects

            var body: HTML {
                [
                    Text(Strings.subjectsListTitle)
                        .style(.heading3),
                    Row {
                        IF(subjects.isEmpty) {
                            Text(Strings.subjectsNoContent)
                                .style(.heading1)
                        }.else {
                            ForEach(in: subjects) { subject in
                                SubjectCard(subject: subject)
                            }
                        }
                    }
                ]
            }
        }

        struct RevisitCard: HTMLComponent {

            let context: TemplateValue<TopicResultContent>

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

        struct SubjectCard: HTMLComponent {

            let subject: TemplateValue<Subject>

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
                .class("col-lg-6")
            }
        }

        struct StatisticsCard: HTMLComponent {

            var body: HTML {
                Card {
                    Text {
                        "Statistikk"
                    }
                    .style(.heading3)
                    .text(color: .dark)
                    .margin(.two, for: .bottom)

                    Text {
                        "Timer øvd de siste ukene:"
                    }
                    Div {
                        Canvas().id("practice-time-histogram")
                    }
                    .class("mt-3 chartjs-chart")
                }
            }
        }

        struct CreateContentCard: HTMLComponent {

            var body: HTML {
                Card {
                    Text {
                        "Mangler et fag?"
                    }
                    .style(.heading3)
                    .text(color: .dark)

                    Anchor {
                        "Lag nytt fag"
                    }
                    .href("/subjects/create")
                    .button(style: .light)
                    .class("btn-rounded")
                }
            }
        }

        struct SubjectTestList: HTMLComponent {

            @TemplateValue(SubjectTest.OverviewResponse?.self)
            var test

            var body: HTML {
                Unwrap(test) { test in
                    Text {
                        "Åpen test"
                    }
                    .style(.heading3)
                    Row {
                        Div {
                            SubjectTestCard(test: test)
                        }
                        .column(width: .six, for: .large)
                    }
                }
            }
        }

        struct SubjectTestCard: HTMLComponent {

            @TemplateValue(SubjectTest.OverviewResponse.self)
            var test

            var body: HTML {
                Card {
                    Text {
                        test.title
                    }
                    .style(.heading2)
                    .text(color: .dark)

                    Unwrap(test.endsAt) { endsAt in
                        Text {
                            "Slutter: "
                            endsAt.style(date: .short, time: .medium)
                        }
                    }

                    Button {
                        "Start nå"
                    }
                    .toggle(modal: .id("start-subject-test-modal"))
                    .button(style: .primary)
                    .isRounded()
                }
            }
        }
    }
}
