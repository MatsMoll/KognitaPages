//
//  File.swift
//  
//
//  Created by Mats Mollestad on 16/12/2020.
//

import Foundation

extension Pages {
    public struct DashboardSubjectList: HTMLTemplate {

        static let subjectListID = "subject-list"

        public struct Context {
            let activeSubjects: [Subject.ListOverview]
            let inactiveSubjects: [Subject.ListOverview]

            init(activeSubjects: [Subject.ListOverview], inactiveSubjects: [Subject.ListOverview]) {
                self.activeSubjects = activeSubjects
                self.inactiveSubjects = inactiveSubjects
            }

            public init(subjects: [Subject.ListOverview]) {
                self.activeSubjects = subjects.filter { $0.isActive }
                self.inactiveSubjects = subjects.filter { $0.isActive == false }
            }
        }

        @TemplateValue(Context.self)
        public var context

        public init(context: TemplateValue<Context> = .root()) {
            self.context = context
        }

        public var body: HTML {
            Div {
                Subject.Templates.ActiveSubjects(subjects: context.activeSubjects)
                InactiveSubjectsSection(subjects: context.inactiveSubjects)
            }
            .id(DashboardSubjectList.subjectListID)
        }

        struct InactiveSubjectsSection: HTMLComponent {

            @TemplateValue([Subject.ListOverview].self)
            var subjects

            var body: HTML {
                NodeList {
                    Text { "Andre emner" }
                        .style(.heading3)
                    IF(subjects.isEmpty) {
                        Text { "Det finnes ingen andre emner" }
                            .style(.heading4)
                    }.else {
                        Row {
                            ForEach(in: subjects) { subject in
                                SubjectCard(subject: subject)
                            }
                        }
                    }
                }
            }
        }
    }
    
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
            Card {
                Text { "Du har ikke verifisert eposten din" }
                    .font(style: .bold)

                Text { "Dette må gjøres før du kan få tilgang til funksjonaliteten i Kognita. Vær obs på at denne kan havne i søppelpost eller spam." }
            }
            .header {
                Text { "Velkommen! 👋🏼" }
                    .style(.heading2)
            }
            .modifyHeader { $0.background(color: .warning) }
        }
    }
    
    struct CreateSubjectCard: HTMLComponent {

        var body: HTML {
            Card {
                Text { "Mangler et fag?" }
                    .style(.heading3)
                    .text(color: .dark)

                Anchor { "Lag nytt fag" }
                    .href("/subjects/create")
                    .button(style: .light)
                    .class("btn-rounded")
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
    
    struct SubjectTestList: HTMLComponent {

        @TemplateValue(SubjectTest.UserOverview?.self)
        var test

        var body: HTML {
            Unwrap(test) { test in
                Text { "Åpen test" }
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

                Text { test.title }
                    .style(.heading2)
                    .text(color: .dark)

                Unwrap(test.endsAt) { (endsAt: TemplateValue<Date>) in
                    Text {
                        "Slutter: "
                        endsAt.style(date: .short, time: .medium)
                    }
                }

                IF(test.hasSubmitted) {
                    Anchor { "Se resultatet" }
                        .href(test.testResultUri)
                        .button(style: .success)
                        .isRounded()
                }
                .else {
                    Button { "Start nå" }
                        .toggle(modal: .id("start-subject-test-modal"))
                        .button(style: .primary)
                        .isRounded()
                }
            }
            .header {
                Text { test.subjectName }
                    .style(.heading3)
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
    
    struct RecommendedRecapCard: HTMLComponent {

        let recap: TemplateValue<RecommendedRecap>

        var body: HTML {
            Card {

                Text {
                    "Basert på aktiviteten din anbefaler vi å repetere "
                    Italic { recap.topicName }
                    " innen "
                    Italic { recap.subjectName }
                    " før "
                    recap.revisitAt.style(date: .short, time: .none)
                }
                .text(color: .dark)

                PracticeSession.Templates.CreateModal.button(
                    subjectID: recap.subjectID,
                    topicID: recap.topicID,
                    topicDescription: recap.topicName
                ) {
                    MaterialDesignIcon(.loop)
                        .margin(.one, for: .right)
                    "Repeter nå"
                }
                .button(style: .primary)
                .isRounded()
            }
            .header {
                Text {
                    MaterialDesignIcon(.loop)
                        .margin(.one, for: .right)
                    "Repeter "
                    recap.topicName
                }
                .style(.heading3)
                .text(color: .white)
            }
            .modifyHeader { $0.background(color: .primary) }
            .footer {
                Div {
                    Text {
                        recap.resultScore.timesHundred.twoDecimals
                        "%"
                        Small { recap.topicName }
                            .margin(.one, for: .left)
                    }
                    .style(.paragraph)
                    .font(style: .bold)
                    .margin(.two, for: .bottom)

                    KognitaProgressBar(value: recap.resultScore.timesHundred)
                }
                .margin(.two, for: .vertical)
            }
        }
    }
    
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
                .fetch(url: "/subjects/search", resultTagID: DashboardSubjectList.subjectListID)
            }
        }
    }
}
