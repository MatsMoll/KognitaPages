import Foundation
import BootstrapKit

extension TestSession.Results {
    var readableScorePersentage: Double {
        (scoreProsentage * 10000).rounded() / 100
    }

    var scoreString: String {
        var string = "\(readableScorePersentage)%"
        if scoreProsentage >= 1 {
            string += " 💯"
        } else if scoreProsentage >= 0.8 {
            string += " 🔥"
        } else if scoreProsentage >= 0.5 {
            string += " 😎"
        }
        return string
    }

    var readableScore: Double {
        (score * 100).rounded() / 100
    }

    var startPracticeCall: String {
        "startPracticeSession(\(topicResults.map { $0.id }), \(subjectID));"
    }

    var timeUsed: TimeInterval { endedAt.timeIntervalSince(executedAt) }
}

extension TestSession.Templates {

    public struct Results: HTMLTemplate {

        public struct Context {
            let user: User
            let results: TestSession.Results

            public init(user: User, results: TestSession.Results) {
                self.user = user
                self.results = results
            }
        }

        var breadcrumbs: [BreadcrumbItem] {
            [
                BreadcrumbItem(link: "/practice-sessions/history", title: ViewWrapper(view: Strings.menuPracticeHistory.localized()))
            ]
        }

        public init() {}

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Resultat", description: "Resultat"))
            ) {
                PageTitle(title: context.results.testTitle, breadcrumbs: breadcrumbs)

                Row {
                    Div {
                        Card {
                            Text { "Total score" }
                            Text { context.results.scoreString }
                                .style(.heading3)
                                .text(color: .dark)

                            Text {
                                context.results.readableScore
                                " poeng"
                            }
                        }

                        Card {
                            Text { "Tid brukt" }
                            Text { context.results.timeUsed.timeString }
                                .style(.heading3)
                                .text(color: .dark)
                        }
                    }
                    .column(width: .four, for: .large)
                    .column(width: .twelve)
                    Div {
                        IF(context.results.canPractice) {
                            PracticeCard(startPracticeSessionCall: context.results.startPracticeCall)
                        }
                        Card {
                            H4(Strings.histogramTitle)
                                .class("header-title mb-4")
                            Div {
                                Canvas().id("practice-time-histogram")
                            }
                            .class("mt-3 chartjs-chart")
                        }
                    }
                    .column(width: .eight, for: .large)
                    .column(width: .twelve)
                }

                IF(context.results.shouldPresentDetails) {
                    Row {
                        Text { "Temaer" }
                            .style(.heading3)
                            .column(width: .twelve)
                    }

                    Row {
                        IF(context.results.topicResults.count == 1) {
                            ForEach(in: context.results.topicResults) { topic in
                                Div { TopicOverview(testIsOpen: context.results.testIsOpen, result: topic) }
                                    .column(width: .twelve)
                            }
                        }.else {
                            ForEach(in: context.results.topicResults) { topic in
                                Div { TopicOverview(testIsOpen: context.results.testIsOpen, result: topic) }
                                    .column(width: .four, for: .large)
                            }
                        }
                    }
                }
            }
            .scripts {
                Script().source("/assets/js/vendor/Chart.bundle.min.js")
                Script(source: "/assets/js/practice-session-histogram.js")
                Script(source: "/assets/js/practice-session-create.js")
            }
        }

        struct TestOverview: HTMLComponent {

            let result: TemplateValue<TestSession.Results>

            var body: HTML {
                Card {
                    Text {
                        result.testTitle
                    }
                    .style(.heading2)
                    .text(color: .dark)

                    Text {
                        result.score + " Poeng"
                        Small { result.readableScorePersentage + "%" }
                            .margin(.one, for: .left)

                    }
                    .font(style: .bold)
                    .margin(.two, for: .bottom)
                    .text(color: .secondary)

                    KognitaProgressBar(value: result.readableScorePersentage)
                }
            }
        }

        struct TopicOverview: HTMLComponent {

            let testIsOpen: TemplateValue<Bool>
            let result: TemplateValue<TestSession.Results.Topic>

            var body: HTML {
                CollapsingCard {
                    Text {
                        result.name
                    }
                    .style(.heading3)
                    .text(color: .dark)

                    Text {
                        result.score.twoDecimals + " Poeng"
                        Small { result.readableScoreProsentage.twoDecimals + "%" }
                            .margin(.one, for: .left)

                    }
                    .font(style: .bold)
                    .margin(.two, for: .bottom)
                    .text(color: .secondary)

                    KognitaProgressBar(value: result.readableScoreProsentage)
                }
                .content {
                    Div {
                        ForEach(in: result.taskResults) { task in
                            Div {
                                TaskOverview(
                                    testIsOpen: testIsOpen,
                                    task: task
                                )
                            }
                            .class("list-group-item")
                        }
                    }
                    .class("list-group list-group-flush")
                }
                .collapseId(result.collapseID)
                .isShown(true)
            }
        }

        struct TaskOverview: HTMLComponent {

            let testIsOpen: TemplateValue<Bool>
            let task: TemplateValue<TestSession.Results.Task>

            var body: HTML {
                Anchor {
                    KognitaProgressBadge(value: task.score.timesHundred.twoDecimals)

                    Text { task.question }
                        .text(color: .secondary)
                        .margin(.three, for: .right)
                        .margin(.one, for: .bottom)

                    Button {
                        "Se løsningsforslag"
                        IF(testIsOpen) {
                            Break()
                            Small { "Dette blir tilgjengelig når alle har levert" }
                        }
                    }
                    .button(style: .light)
                    .isDisabled(testIsOpen)
                    .float(.right)
                }
                .href(task.taskResultUri)
            }
        }

        struct PracticeCard: HTMLComponent {

            let startPracticeSessionCall: TemplateValue<String>

            var body: HTML {
                Card {
                    Text { "Visste du at du kan øve med Kognita?" }
                        .style(.heading3)
                        .text(color: .dark)

                    Text { "Prøv øvefunksjonen for å øve litt på temaene du hadde på denne prøven" }

                    Button { "Begynn å øve" }
                        .on(click: startPracticeSessionCall)
                        .button(style: .success)
                        .isRounded()
                }
            }
        }
    }
}

extension TestSession.Results.Topic {
    var collapseID: String {
        name.replacingOccurrences(of: " ", with: "-")
    }
}

extension TestSession.Results.Task {
    var taskResultUri: String {
        "tasks/\(pivotID)/result"
    }
}
