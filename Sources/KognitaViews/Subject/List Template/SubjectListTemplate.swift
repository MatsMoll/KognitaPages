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

extension Subject.Templates {
    struct ActiveSubjects: HTMLComponent {

        let subjects: TemplateValue<[Subject.ListOverview]>

        var body: HTML {
            IF(subjects.isEmpty) {
                Text { "Du har ingen aktive emner enda. Gå inn på et emnet for å gjøre det aktivt!" }
                    .style(.heading3)
                    .margin(.four, for: .vertical)
            }.else {
                Text { "Dine emner!" }
                    .style(.heading3)
                Row {
                    ForEach(in: subjects) { subject in
                        SubjectCard(subject: subject)
                    }
                }
                .margin(.four, for: .bottom)
            }
        }
    }
}

extension Subject.Templates {
    public struct ListOverview: HTMLTemplate {

        public struct Context {
            let user: User
            let list: Subject.ListContent
            let wasIncorrectPassword: Bool

            public init(user: User, list: Subject.ListContent, wasIncorrectPassword: Bool) {
                self.user = user
                self.list = list
                self.wasIncorrectPassword = wasIncorrectPassword
            }
        }

        public init() {}

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Temaliste", description: "Temaliste"))
            ) {

                PageTitle(title: Strings.subjectsTitle.localized())

                Row {
                    Div {
                        IF(context.user.isEmailVerified == false) {
                            VerifyEmailSignifier()
                        }
                        SubjectTestList(test: context.list.openedTest)
                        Subject.Templates.ActiveSubjects(subjects: context.list.activeSubjects)

//                        ContinuePracticeSessionCard(
//                            ongoingSessionPath: context.
//                        )
                        SubjectListSection(subjects: context.list.inactiveSubjects)
                    }
                    .column(width: .eight, for: .large)
                    Div {
                        StatisticsCard()
                        User.Templates.ProfileCard(user: context.user)
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
                Script().source("https://cdn.jsdelivr.net/npm/marked/marked.min.js")
                Script().source("/assets/js/markdown-renderer.js")
                IF(context.wasIncorrectPassword) {
                    Script {
"""
$("#start-subject-test-modal").modal('show');
"""
                    }
                }

            }
            .active(path: "/subjects")
            .modals {
                Unwrap(context.list.openedTest) { test in
                    SubjectTest.Templates.StartModal(
                        test: test,
                        wasIncorrectPassword: context.wasIncorrectPassword
                    )
                }
            }
        }

        struct SubjectListSection: HTMLComponent {

            @TemplateValue([Subject.ListOverview].self)
            var subjects

            var body: HTML {
                NodeList {
                    Text(Strings.subjectsListTitle)
                        .style(.heading3)
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
                }
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
    }
}

extension Subject.Templates {

    struct SubjectCard: HTMLComponent {

        let subject: TemplateValue<Subject.ListOverview>

        var body: HTML {
            Div {
                Anchor {
                    Div {
                        Div {
                            H3 { subject.name }
                            Badge { subject.category }
                                .background(color: .light)
                            IF(subject.isActive) {
                                Badge { "Aktivt" }
                                    .background(color: .light)
                                    .margin(.one, for: .left)
                            }
                        }
                        .class("card-header bg-" + subject.colorClass.rawValue)
                        .text(color: .white)
                        Div {
                            P {
                                subject.description
                                    .escaping(.unsafeNone)
                            }
                            .class("render-markdown")

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

    struct VerifyEmailSignifier: HTMLComponent {

        var body: HTML {
            Div {
                Div {
                    Text {
                        "Velkommen! 👋🏼"
                    }
                    .style(.heading2)
                }
                .class("card-header")
                .background(color: .warning)

                Div {
                    Text {
                        "Du har ikke verifisert eposten din"
                    }
                    .font(style: .bold)

                    Text {
                        "Dette må gjøres før du kan få tilgang til funksjonaliteten i Kognita. Vær obs på at denne kan havne i søppelpost eller spam."
                    }
                }
                .class("card-body")
            }
            .class("card")
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
                    .column(width: .twelve)
                }
            }
        }
    }

    struct SubjectTestCard: HTMLComponent {

        var test: TemplateValue<SubjectTest.OverviewResponse>

        var body: HTML {
            Card {

                Text {
                    test.title
                }
                .style(.heading2)
                .text(color: .dark)

                Unwrap(test.endsAt) { (endsAt: TemplateValue<Date>) in
                    Text {
                        "Slutter: "
                        endsAt.style(date: .short, time: .medium)
                    }
                }

                IF(test.hasSubmitted) {
                    Anchor {
                        "Se resultatet"
                    }
                    .href(test.testResultUri)
                    .button(style: .success)
                    .isRounded()
                }
                .else {
                    Button {
                        "Start nå"
                    }
                    .toggle(modal: .id("start-subject-test-modal"))
                    .button(style: .primary)
                    .isRounded()
                }
            }
            .header {
                Text {
                    test.subjectName
                }.style(.heading3)
            }
            .modifyHeader { header in
                header.modify(if: test.hasSubmitted) {
                    $0.background(color: .success)
                        .text(color: .white)
                }
                .modify(if: test.hasSubmitted == false) {
                    $0.background(color: .danger)
                        .text(color: .white)
                }
            }
        }
    }
}

extension SubjectTest.OverviewResponse {
    var testResultUri: String {
        guard let sessionID = testSessionID else {
            return ""
        }
        return "/test-sessions/\(sessionID)/results"
    }
}

extension Anchor {
    public func isRounded(_ condtion: Conditionable = true) -> Anchor {
        self.modify(if: condtion) {
            $0.class("btn-rounded")
        }
    }
}
