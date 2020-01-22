import KognitaCore
import BootstrapKit

extension TestSession.Results {
    var readableScorePersentage: Double {
        scoreProsentage * 100
    }
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

        public init() {}

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Resultat", description: "Resultat"))
            ) {
                PageTitle(title: context.results.testTitle)

                Row {
                    Div {
                        TestOverview(result: context.results)
                    }
                    .column(width: .twelve)

                    ForEach(in: context.results.topicResults) { topic in
                        Div {
                            TopicOverview(result: topic)
                        }
                        .column(width: .four, for: .large)
                    }
                }
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

            let result: TemplateValue<TestSession.Results.Topic>

            var body: HTML {
                Card {
                    Text {
                        result.name
                    }
                    .style(.heading3)
                    .text(color: .dark)

                    Text {
                        result.score + " Poeng"
                        Small { result.readableScoreProsentage + "%" }
                            .margin(.one, for: .left)

                    }
                    .font(style: .bold)
                    .margin(.two, for: .bottom)
                    .text(color: .secondary)

                    KognitaProgressBar(value: result.readableScoreProsentage)
                }
            }
        }
    }
}
