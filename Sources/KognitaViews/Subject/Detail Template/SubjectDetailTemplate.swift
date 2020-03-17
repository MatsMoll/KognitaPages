//
//  SubjectDetailTemplate.swift
//  App
//
//  Created by Mats Mollestad on 26/02/2019.
//
// swiftlint:disable line_length nesting

import BootstrapKit
import KognitaCore

extension Subject.Details {
    var makeActiveCall: String {
        "markAsActive(\(subject.id ?? 0))"
    }

    var topicIDsJSList: String {
        "[\(topics.map { $0.id }.reduce("") { $0 + "\($1), " }.dropLast(2))]"
    }

    var canCreateTasks: Bool { isModerator || canPractice }

    var createContentUri: String { "/creator/subjects/\(subject.id ?? 0)/overview" }
}

extension Subject.Templates {
    public struct Details: HTMLTemplate {

        public struct Context {
            let base: BaseTemplateContent
            let user: User
            let details: Subject.Details

            public init(
                user: User,
                details: Subject.Details
            ) {
                self.user = user
                self.base = .init(title: details.subject.name, description: details.subject.name)
                self.details = details
            }
        }

        public init() {}

        let breadcrumbs: [BreadcrumbItem] = [
            BreadcrumbItem(link: "../subjects", title: .init(view: Strings.subjectTitle.localized()))
        ]

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: context.base
            ) {
                PageTitle(
                    title: context.details.subject.name,
                    breadcrumbs: breadcrumbs
                )
                Row {
                    Div {
                        IF(context.user.isEmailVerified == false) {
                            VerifyEmailSignifier()
                        }
                        UnactiveSubjectCard(details: context.details)
                        SubjectTestList(test: context.details.openTest)
                        SubjectCard(
                            details: context.details,
                            topicIDs: context.details.topicIDsJSList
                        )
                        Row {
                            IF(context.details.topics.isEmpty) {
                                Div {
                                    Text(Strings.subjectsNoTopics)
                                        .class("page-title")
                                        .style(.heading3)
                                }
                                .class("page-title-box")
                            }.else {
                                TopicList(
                                    topics: context.details.topics,
                                    subjectID: context.details.subject.id,
                                    canPractice: context.details.canPractice
                                )
                            }
                        }
                    }
                    .column(width: .eight, for: .large)
                    Div {
                        StatisticsCard()
                        IF(context.details.canCreateTasks) {
                            CreateContentCard(createContentUri: context.details.createContentUri)
                        }
                        IF(context.details.isModerator) {
                            SubjectTestSignifier(subjectID: context.details.subject.id)
                        }
                    }
                    .column(width: .four, for: .large)
                }
            }
            .scripts {
                Script().source("/assets/js/vendor/Chart.bundle.min.js")
                Script().source("/assets/js/results/weekly-histogram.js")
                Script().source("/assets/js/practice-session-create.js")
                Script().source("/assets/js/subject/mark-as-active.js")
                Script().source("https://cdn.jsdelivr.net/npm/marked/marked.min.js")
                Script().source("/assets/js/markdown-renderer.js")
            }
            .modals {
                IF(context.details.canCreateTasks) {
                    CreateContentModal(
                        subject: context.details.subject,
                        isModerator: context.details.isModerator
                    )
                }
                Unwrap(context.details.openTest) { test in
                    SubjectTest.Templates.StartModal(
                        test: test,
                        wasIncorrectPassword: .constant(false)
                    )
                }
            }
        }

        struct SubjectCardContext {
            let subject: Subject
            let level: User.SubjectLevel
        }

        struct SubjectCard: HTMLComponent {

            @TemplateValue(Subject.Details.self)
            var details

            @TemplateValue(String.self)
            var topicIDs

            var body: HTML {
                Card {
//                    KognitaProgressBadge(value: userLevel.correctProsentage)

                    Text { details.subject.name }
                        .text(color: .dark)
                        .margin(.zero, for: .top)
                        .style(.heading2)

                    IF(details.canPractice == false) {
                        Text {
                            "Du har dessverre ikke tilgang til øvingsmodus helt enda."
                        }
                    }

                    Button {
                        Italic().class("mdi mdi-book-open-variant")
                        " "
                        Strings.subjectStartSession.localized()
                    }
                    .type(.button)
                    .class("btn-rounded")
                    .button(style: .primary)
                    .margin(.three, for: .bottom)
                    .on(click: "startPracticeSession(" + topicIDs + ", " + details.subject.id + ")")
                    .isDisabled(details.canPractice == false)

                    Text {
                        details.subject.description
                            .escaping(.unsafeNone)
                    }
                    .class("font-13")
                    .text(color: .muted)
                    .margin(.three, for: .bottom)
                    .style(.paragraph)
                    .class("render-markdown")
                }
                .footer {
                    UnorderedList {
                        ListItem {
                            Text {
                                details.subjectLevel.correctProsentage
                                "%"
                                Small { details.subjectLevel.correctScoreInteger }
                                    .margin(.one, for: .left)
                            }
                            .style(.paragraph)
                            .font(style: .bold)
                            .margin(.two, for: .bottom)

                            KognitaProgressBar(value: details.subjectLevel.correctProsentage)
                        }
                        .class("list-group-item")
                        .padding(.three)
                    }
                    .class("list-group list-group-flush")
                }
                .modifyFooter {
                    $0.padding(.zero)
                }
                .display(.block)
            }
        }

        struct CreateContentCard: HTMLComponent {

            let createContentUri: TemplateValue<String>

            var body: HTML {
                Card {
                    Text { "Gå gjennom innholdet" }
                        .style(.heading3)
                        .text(color: .dark)

                    Anchor { "Se innholdet" }
                        .href(createContentUri)
                        .button(style: .light)
                        .isRounded()
                }
            }
        }

        struct UnactiveSubjectCard: HTMLComponent {

            let details: TemplateValue<Subject.Details>

            var body: HTML {
                IF(details.isActive == false) {
                    Card {
                        Text {
                            "Minimal tilgang"
                        }
                        .style(.heading2)
                        .text(color: .dark)

                        Text {
                            "Du har ikke "
                            details.subject.name
                            " som et aktiv fag."
                        }
                        Text {
                            "Trykk på knappen nedenfor for å få tilgang til mere funksjonalitet"
                        }

                        Button {
                            "Gjør faget aktivt"
                        }
                        .button(style: .primary)
                        .isRounded()
                        .on(click: details.makeActiveCall)
                    }
                }
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
                        "Timer øvet de siste ukene:"
                    }
                    Div {
                        Canvas().id("practice-time-histogram")
                    }
                    .class("mt-3 chartjs-chart")
                }
            }
        }

        struct SubjectTestSignifier: HTMLComponent {

            @TemplateValue(Subject.ID?.self)
            var subjectID

            var body: HTML {
                Card {
                    Text {
                        "Prøver"
                    }
                    .style(.heading3)
                    .text(color: .dark)

                    Anchor {
                        "Se alle prøver"
                    }
                    .href(subjectID + "/subject-tests")
                    .button(style: .light)
                    .class("btn-rounded")
                }
            }
        }
    }
}
