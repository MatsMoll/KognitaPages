//
//  SubjectDetailTemplate.swift
//  App
//
//  Created by Mats Mollestad on 26/02/2019.
//
// swiftlint:disable line_length nesting

import BootstrapKit

extension Subject.Details {
    var makeActiveCall: String {
        "markAsActive(\(subject.id))"
    }

    var makeInactiveCall: String {
        "markAsInactive(\(subject.id))"
    }

    var topicIDsJSList: String {
        "[\(topics.map { $0.id }.reduce("") { $0 + "\($1)," }.dropLast(1))]"
    }

    var canCreateTasks: Bool { isModerator || canPractice }

    var createContentUri: String { "/creator/subjects/\(subject.id)/overview" }
    var compendiumUri: String { "/subjects/\(subject.id)/compendium" }
    var startPracticeSessionCall: String { "startPracticeSessionWithTopicIDs(\(topicIDsJSList), \(subject.id))" }
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
                self.base = .init(title: details.subject.name, description: details.subject.name, showCookieMessage: false)
                self.details = details
            }
        }

        public init() {}

        let breadcrumbs: [BreadcrumbItem] = [
            BreadcrumbItem(link: ViewWrapper(stringLiteral: Paths.subjects), title: .init(view: Strings.subjectTitle.localized()))
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
                        SubjectCard(details: context.details)
                        Row {
                            Div {
                                Text { "Temaer" }
                                    .style(.heading2)
                            }
                            .column(width: .twelve)

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
                        Row {
                            Div {
                                Text { "Eksamener" }
                                    .style(.heading2)
                            }
                            .column(width: .twelve)

                            IF(context.details.exams.isEmpty) {
                                Div {
                                    Text { "Det finnes ingen oppgaver som er koblet opp til en eksamen enda" }
                                        .style(.heading5)
                                }
                                .column(width: .twelve)
                            }.else {
                                ForEach(in: context.details.exams) { exam in
                                    Div {
                                        ExamCard(exam: exam)
                                    }
                                    .column(width: .six, for: .large)
                                    .column(width: .twelve)
                                }
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
                        MakeSubjectInactiveCard(details: context.details)
                    }
                    .column(width: .four, for: .large)
                }

                PracticeSession.Templates.CreateModal()
                ResourceListModal()
            }
            .scripts {
                Script().source("/assets/js/vendor/Chart.bundle.min.js")
                Script().source("/assets/js/results/weekly-histogram.js")
                Script().source("/assets/js/subject/mark-as-active.js")
                Script().source("/assets/js/subject/mark-as-inactive.js")
                Script().source("https://cdn.jsdelivr.net/npm/marked/marked.min.js")
                Script().source("/assets/js/markdown-renderer.js")
                Script(source: "/assets/js/exam/start.js")
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
            let level: Subject.UserLevel
        }

        struct SubjectCard: HTMLComponent {

            @TemplateValue(Subject.Details.self)
            var details

            var body: HTML {
                Card {
                    IF(details.isModerator) {
                        Anchor { "Rediger" }
                            .button(style: .light)
                            .float(.right)
                            .href(details.editUri)
                            .isRounded()
                    }
                    
                    Text { details.subject.name }
                        .text(color: .dark)
                        .margin(.zero, for: .top)
                        .style(.heading2)

                    IF(details.canPractice == false) {
                        Text { "Du har dessverre ikke tilgang til øvingsmodus helt enda." }
                    }

                    PracticeSession.Templates.CreateModal.button(
                        subjectID: details.subject.id,
                        topicID: details.topicIDsJSList,
                        topicDescription: details.subject.name
                    ) {
                        MaterialDesignIcon(.trophy)
                            .margin(.one, for: .right)
                        Strings.subjectStartSession.localized()
                    }
                    .type(.button)
                    .isRounded()
                    .button(style: .primary)
                    .margin(.three, for: .bottom, sizeClass: .medium)
                    .margin(.two, for: .bottom)
                    .isDisabled(details.canPractice == false)

                    Break().display(.none, breakpoint: .medium)

                    Anchor {
                        MaterialDesignIcon(.openBook)
                            .margin(.one, for: .right)
                        "Les kompendiet"
                    }
                    .button(style: .light)
                    .margin(.one, for: .left, sizeClass: .medium)
                    .margin(.three, for: .bottom)
                    .href(details.compendiumUri)
                    .isRounded()

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
                    Text { "Lag og se eksisterend innhold" }
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
                    Text(Strings.histogramTitle)
                        .style(.heading3)
                        .text(color: .dark)
                        .margin(.two, for: .bottom)

                    Div {
                        Canvas().id("practice-time-histogram")
                    }
                    .class("mt-3 chartjs-chart")
                }
            }
        }

        struct SubjectTestSignifier: HTMLComponent {

            @TemplateValue(Subject.ID.self)
            var subjectID

            var body: HTML {
                Card {
                    Text {
                        "Prøver"
                    }
                    .style(.heading3)
                    .text(color: .dark)

                    Anchor { "Se alle prøver" }
                        .href(subjectID + "/subject-tests")
                        .button(style: .light)
                        .class("btn-rounded")
                }
            }
        }

        struct MakeSubjectInactiveCard: HTMLComponent {

            let details: TemplateValue<Subject.Details>

            var body: HTML {
                 IF(details.isActive) {
                    Card {
                        Text {
                            "Ikke lenger et fag du trenger?"
                        }
                        .style(.heading3)
                        .text(color: .dark)

                        Button {
                            "Gjør faget inaktivt"
                        }
                        .button(style: .light)
                        .isRounded()
                        .on(click: details.makeInactiveCall)
                    }
                }
            }
        }
    }
}

extension Subject.Templates.Details {
    public struct Unauthenticated: HTMLTemplate {
        
        public struct Context {
            let base: BaseTemplateContent
            let details: Subject.Details

            public init(details: Subject.Details, showCookieMessage: Bool) {
                self.base = .init(title: details.subject.name, description: details.subject.name, showCookieMessage: showCookieMessage)
                self.details = details
            }
        }

        public init() {}

        let breadcrumbs: [BreadcrumbItem] = [
            BreadcrumbItem(link: ViewWrapper(stringLiteral: Paths.subjects), title: .init(view: Strings.subjectTitle.localized()))
        ]

        public var body: HTML {

            ContentBaseTemplate(
                baseContext: context.base
            ) {
                PageTitle(
                    title: context.details.subject.name,
                    breadcrumbs: breadcrumbs
                )
                Row {
                    Div {
                        SubjectCard(details: context.details)
                        Row {
                            Div {
                                Text { "Temaer" }
                                    .style(.heading2)
                            }
                            .column(width: .twelve)

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
                        Row {
                            Div {
                                Text { "Eksamener" }
                                    .style(.heading2)
                            }
                            .column(width: .twelve)

                            IF(context.details.exams.isEmpty) {
                                Div {
                                    Text { "Det finnes ingen oppgaver som er koblet opp til en eksamen enda" }
                                        .style(.heading5)
                                }
                                .column(width: .twelve)
                            }.else {
                                ForEach(in: context.details.exams) { exam in
                                    Div {
                                        Subject.Templates.ExamCard(exam: exam)
                                    }
                                    .column(width: .six, for: .large)
                                    .column(width: .twelve)
                                }
                            }
                        }
                    }
                    .column(width: .eight, for: .large)
                    Div {
                        User.Templates.CreateUserCard()
                    }
                    .column(width: .four, for: .large)
                }
            }
            .scripts {
                Script().source("/assets/js/subject/mark-as-active.js")
                Script().source("https://cdn.jsdelivr.net/npm/marked/marked.min.js")
                Script().source("/assets/js/markdown-renderer.js")
            }
        }
    }
}


struct ResourceListModal: HTMLComponent {
    
    static let modalID = "resource-list-modal"
    static let resultID = "resoruces-list"
    
    static func button(topicID: HTML, topicName: HTML) -> Button {
        Button {
            MaterialDesignIcon(.openBook)
                .margin(.one, for: .right)
            "Se ressurser"
        }
        .button(style: .light)
        .data("topic-id", value: topicID)
        .data("topic-name", value: topicName)
        .isRounded()
        .toggle(modal: .id(ResourceListModal.modalID))
    }
    
    var body: HTML {
        Modal(title: "Ressurser", id: ResourceListModal.modalID) {
            
            Text {
                "Ressurser innen "
                Span().id("topic-name")
            }
            .style(.heading3)
            .text(color: .dark)
            
            Div()
                .id(ResourceListModal.resultID)
                .margin(.three, for: .top)
            
            Button {
                "Lukk"
                MaterialDesignIcon(.close)
                    .margin(.one, for: .left)
            }
            .dismissModal()
            .button(style: .light)
        }
        .set(data: "topic-name", type: .node, to: "topic-name")
    }
    
    var scripts: HTML {
        NodeList {
            body.scripts
            Script {
                """
                $('#\(ResourceListModal.modalID)').on('show.bs.modal', function (event) {
                  let button = $(event.relatedTarget);
                  let topicID = button.data('topic-id');
                  \(Script.fetchHTML(resultNodeID: ResourceListModal.resultID, url: #""/topics/" + topicID + "/resources";"#))
                })
                """
            }
            Script(source: "/assets/js/resources/fetch-html.js")
            Script(source: "/assets/js/term/delete.js")
        }
    }
}

extension Script {
    static func fetchHTML(resultNodeID: String, url: String) -> String {
        """
        let url = \(url)
        let resultID = "\(resultNodeID)"
        $("#" + resultID).html('<div class="d-flex justify-content-center"><div class="spinner-border" role="status"></div></div>');
        fetch(url, {
            method: "GET",
            headers: {
                "Accept": "application/html, text/plain, */*",
            }
        })
        .then(function (response) {
            if (response.ok) {
                return response.text();
            } else {
                throw new Error(response.statusText);
            }
        })
        .then(function (html) {
            $("#" + resultID).html(html);
            renderMarkdownNodesIn($("#" + resultID));
        })
        .catch(function (error) {
            console.log(error);
        });
        """
    }
}

extension Subject.Details {
    var editUri: String { "/subjects/\(subject.id)/edit"}
}
