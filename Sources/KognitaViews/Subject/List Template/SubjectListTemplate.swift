//
//  SubjectListTemplate.swift
//  App
//
//  Created by Mats Mollestad on 26/02/2019.
//

import Foundation
import BootstrapKit

extension Subject {
    public struct Templates {}
}

extension Subject.Templates {
    /// A component displaying the active subjects
    struct ActiveSubjects: HTMLComponent {
        
        /// The subjects that are active
        let subjects: TemplateValue<[Subject.ListOverview]>

        var body: HTML {
            IF(subjects.isEmpty) {
                Text { "Du har ingen aktive emner ennå. Gå inn på et emnet for å gjøre det aktivt!" }
                    .style(.heading3)
                    .margin(.four, for: .vertical)
            }.else {
                Text { "Dine emner" }
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
    /// A template displaying a list of all subjects
    /// Should probably be renamed to a Dashboard as it is getting more functions
    /// And are a landing page for logged inn users
    public struct ListOverview: HTMLTemplate {
        
        /// The context needed to render the template
        public struct Context {
            let user: User
            let list: Dashboard
            let wasIncorrectPassword: Bool
            let recentlyActiveDiscussions: Bool

            var listComponentContext: ListComponent.Context { .init(activeSubjects: list.activeSubjects, inactiveSubjects: list.inactiveSubjects) }

            public init(user: User, list: Dashboard, wasIncorrectPassword: Bool, recentlyActiveDiscussions: Bool) {
                self.user = user
                self.list = list
                self.wasIncorrectPassword = wasIncorrectPassword
                self.recentlyActiveDiscussions = recentlyActiveDiscussions
            }
        }

        public init() {}

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Temaliste", description: "Temaliste", showCookieMessage: false))
            ) {

                PageTitle(title: Strings.subjectsTitle.localized())

                Row {
                    Div {
                        IF(context.user.isEmailVerified == false) {
                            VerifyEmailSignifier()
                        }
                        Unwrap(context.list.recommendedRecap) { recap in
                            RecommendedRecapCard(recap: recap)
                            PracticeSession.Templates.CreateModal()
                        }
                        SubjectTestList(test: context.list.openedTest)

                        //                        ContinuePracticeSessionCard(
                        //                            ongoingSessionPath: context.
                        //                        )

                        Text { "Emner" }.style(.heading4)
                        SearchCard()
                        ListComponent(context: context.listComponentContext)
                    }
                    .column(width: .eight, for: .large)
                    Div {
                        StatisticsCard()
                        User.Templates.ProfileCard(user: context.user)
                        UserDiscussionCard(recentlyActiveDiscussions: context.recentlyActiveDiscussions)
                        IF(context.user.isAdmin) {
                            CreateContentCard()
                        }
                    }
                    .column(width: .four, for: .large)
                }
            }
            .scripts {
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

//        struct RevisitCard: HTMLComponent {
//
//            let context: TemplateValue<TopicResultContent>
//
//            var practiceFunction: HTML { "startPracticeSession([" + context.topic.id + "], " + context.subject.id + ");" }
//
//            var body: HTML {
//                Div {
//                    Card {
//                        Badge {
//                            Localized(
//                                key: Strings.subjectRepeatDays,
//                                context: context
//                            )
//                        }
//                        .float(.right)
//                        .background(color: .warning)
//
//                        Text {
//                            Anchor {
//                                context.topic.name
//                            }
//                            .on(click: practiceFunction)
//                            .href("#")
//                            .text(color: .dark)
//                        }
//                        .style(.heading4)
//                        .class("mt-0")
//
//                        Text(Strings.subjectRepeatDescription, with: context)
//                            .text(color: .muted)
//                            .class("font-13 mb-3")
//
//                        Anchor {
//                            Button {
//                                Italic().class("mdi mdi-book-open-variant")
//                                " " +
//                                    Localized(key: Strings.subjectRepeatStart)
//                            }
//                            .type(.button)
//                            .button(style: .primary)
//                            .class("btn-rounded mb-1")
//                        }
//                        .on(click: practiceFunction)
//                        .href("#")
//                        .text(color: .dark)
//                    }
//                    .display(.block)
//                }
//                .class("col-md-6 col-lg-4")
//            }
//        }

        struct SearchCard: HTMLComponent {

            var body: HTML {
                Card {
                    Form {
                        Label { "Søk på et emne" }
                            .for("name")
                        InputGroup {
                            Input()
                                .type(.text)
                                .placeholder("Søk..")
                                .id("name")
                                .name("name")
                        }
                        .append {
                            Button { "Søk" }
                                .button(style: .primary)
                                .type(.submit)
                        }
                    }
                    .id("subject-list-search-form")
                    .fetch(url: "/subjects/search", resultTagID: ListComponent.subjectListID)
                }
            }
        }

        struct StatisticsCard: HTMLComponent {

            var body: HTML {
                Card {
                    Text(Strings.histogramTitle)
                        .style(.heading3)
                        .text(color: .dark)
                        .margin(.two, for: .bottom)

                    Div { Canvas().id("practice-time-histogram") }
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
                        .class("card-header")
                        .text(color: .white)
                        .modify(if: subject.isActive) { card in
                            card.background(color: .primary)
                        }
                        .modify(if: subject.isActive == false) { card in
                            card.background(color: .success)
                        }

                        Div {
                            P {
                                subject.description
                                    .escaping(.unsafeNone)
                            }
                            .class("render-markdown")

                            Button(Strings.subjectExploreButton)
                                .isRounded()
                                .modify(if: subject.isActive) { card in
                                    card.button(style: .primary)
                                }
                                .modify(if: subject.isActive == false) { card in
                                    card.button(style: .success)
                                }
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

        @TemplateValue(SubjectTest.UserOverview?.self)
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

        var test: TemplateValue<SubjectTest.UserOverview>

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

    struct UserDiscussionCard: HTMLComponent {

        let recentlyActiveDiscussions: TemplateValue<Bool>

        var body: HTML {
            Card {

                Text { "Dine diskusjoner"
                    IF(recentlyActiveDiscussions == true) {
                        Span { "New" }
                            .class("badge badge-primary")
                            .margin(.one, for: .left)
                    }

                }
                .style(.heading3)
                .text(color: .dark)

                Anchor { "Se diskusjoner" }
                    .href("/task-discussion/user")
                    .button(style: .light)
                    .class("btn-rounded")
            }
        }
    }
}

extension SubjectTest.UserOverview {
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
