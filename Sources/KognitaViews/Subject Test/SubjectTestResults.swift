import BootstrapKit
import KognitaCore

extension SubjectTest.Results {
    var readableAveragePercentage: Int {
        if averageScore.isNaN {
            return 0
        } else {
            return Int((averageScore * 100).rounded())
        }
    }
}

extension SubjectTest.Results.MultipleChoiseTaskResult {
    var numberOfSubmissions: Int {
        choises.reduce(into: 0) { $0 += $1.numberOfSubmissions }
    }
}

extension SubjectTest.Results.MultipleChoiseTaskResult.Choise {

    var readablePercentage: Int {
        Int((percentage * 100).rounded())
    }

    var percentageTimesHundred: Double {
        percentage * 100
    }
}

extension SubjectTest.Templates {
    public struct Results: HTMLTemplate {

        public struct Context {
            let user: User
            let results: SubjectTest.Results

            public init(user: User, results: SubjectTest.Results) {
                self.user = user
                self.results = results
            }
        }

        var breadcrumbs: [BreadcrumbItem]  {
            [
                BreadcrumbItem(
                    link: "/subjects",
                    title: "Fag oversikt"
                ),
                BreadcrumbItem(
                    link: ViewWrapper(view: "/subjects/" + self.context.results.subjectID),
                    title: ViewWrapper(view: self.context.results.subjectName)
                ),
                BreadcrumbItem(
                    link: ViewWrapper(view: "/subjects/" + self.context.results.subjectID + "/subject-tests"),
                    title: "Prøver"
                )
            ]
        }

        public init() {}

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Resultater", description: "Resultater"))
            ) {
                PageTitle(title: context.results.title, breadcrumbs: breadcrumbs)
                Row {

                    Div {
                        Card {
                            Text {
                                "Resultat histogram"
                            }
                            .class("header-title mb-4")

                            Div {
                                Canvas().id("score-histogram")
                            }
                            .class("mt-3 chartjs-chart")
                        }
                    }
                    .column(width: .eight, for: .large)

                    Div {
                        Card {
                            Text {
                                "Snitt score"
                            }
                            Text {
                                context.results.readableAveragePercentage
                                "%"
                            }
                            .style(.heading3)
                            .text(color: .dark)
                        }
                    }
                    .column(width: .four, for: .large)
                }

                Text {
                    "Oppgaver"
                }
                .style(.heading3)

                Row {
                    ForEach(in: context.results.taskResults) { result in
                        Div {
                            MultipleChoiseTaskResult(result: result)
                        }
                        .column(width: .six, for: .large)
                    }
                }
            }
            .header {
                Stylesheet(url: "https://cdn.jsdelivr.net/npm/katex@0.11.1/dist/katex.min.css")
            }
            .scripts {
                Script(source: "/assets/js/vendor/Chart.bundle.min.js")
                Script(source: "/assets/js/subject-test/score-histogram.js")
                Script().source("https://cdn.jsdelivr.net/npm/marked/marked.min.js")
                Script().source("https://cdn.jsdelivr.net/npm/katex@0.11.1/dist/katex.min.js")
                Script().source("/assets/js/markdown-renderer.js")
            }
        }


        struct MultipleChoiseTaskResult: HTMLComponent {

            let result: TemplateValue<SubjectTest.Results.MultipleChoiseTaskResult>

            var body: HTML {
                Card {

                    Unwrap(result.description) { description in
                        Text {
                            description
                        }
                        .style(.cardText)
                        .class("render-markdown")
                    }

                    Text {
                        result.question
                    }
                    .style(.heading3)

                    Text {
                        result.numberOfSubmissions
                        " svar"
                    }

                    ForEach(in: result.choises) { choise in
                        Choise(choise: choise)
                    }
                }
            }

            struct Choise: HTMLComponent {
                let choise: TemplateValue<SubjectTest.Results.MultipleChoiseTaskResult.Choise>

                var body: HTML {
                    Card {
                        Text {
                            choise.choise
                                .escaping(.unsafeNone)
                        }
                        .class("render-markdown")
                        .style(.lead)
                        
                        Text {
                            choise.numberOfSubmissions
                            " svar"
                            Small { choise.readablePercentage + "%" }
                                .margin(.one, for: .left)
                        }
                        .font(style: .bold)
                        .margin(.zero, for: .bottom)
                        .text(color: .secondary)

                        ProgressBar(
                            currentValue: choise.percentageTimesHundred,
                            valueRange: 0.0...100.0
                        )
                            .bar(size: .medium)
                            .margin(.one, for: .top)
                            .modify(if: choise.isCorrect) {
                                $0.bar(style: .success)
                            }
                            .modify(if: choise.isCorrect == false) {
                                $0.bar(style: .danger)
                            }
                    }
                    .margin(.two, for: .bottom)
                    .class("shadow-none border")
                    .modify(if: choise.isCorrect) {
                        $0.class("border-success")
                    }
                }
            }
        }
    }
}
