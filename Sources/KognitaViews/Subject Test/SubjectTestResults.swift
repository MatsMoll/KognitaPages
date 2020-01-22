import BootstrapKit
import KognitaCore

extension SubjectTest.Results.MultipleChoiseTaskResult.Choise {

    var readablePercentage: Int {
        Int((percentage * 100).rounded())
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

        public init() {}

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Resultater", description: "Resultater"))
            ) {
                PageTitle(title: context.results.title)
                Row {
                    Div {
                        Card {
                            Text {
                                "Snitt score"
                            }
                            Text {
                                context.results.averageScore
                            }
                            .style(.heading3)
                            .text(color: .dark)
                        }
                    }
                    .column(width: .twelve)

                    ForEach(in: context.results.taskResults) { result in
                        Div {
                            MultipleChoiseTaskResult(result: result)
                        }
                        .column(width: .six, for: .large)
                    }
                }
            }
        }


        struct MultipleChoiseTaskResult: HTMLComponent {

            let result: TemplateValue<SubjectTest.Results.MultipleChoiseTaskResult>

            var body: HTML {
                Card {
                    Text {
                        result.question
                    }
                    .style(.heading3)

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
                        }
                        Text {
                            choise.numberOfSubmissions
                            " Svar"
                            Small { choise.readablePercentage + "%" }
                                .margin(.one, for: .left)

                        }
                        .font(style: .bold)
                        .margin(.zero, for: .bottom)
                        .text(color: .secondary)
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
