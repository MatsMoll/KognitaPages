import BootstrapKit
import QTIKit

extension MultipleChoiceTask.Templates {

    public struct ImportQTI: HTMLTemplate {

        public struct Context {
            let user: User
            let tasks: [QTIQuestion]
            let topics: [Topic.WithSubtopics]

            public init(user: User, tasks: [AssessmentItem], topics: [Topic.WithSubtopics]) {
                self.user = user
                self.tasks = tasks.map { item in
                    QTIQuestion(
                        description: item.itemBody.body,
                        question: "Velg det alternativet som stemmer",
                        choices: item.itemBody.choiceInteraction.choices.map { choice in
                            MultipleChoiceTaskChoice.Create.Data(
                                choice: choice.choice,
                                isCorrect: item.response.correctResponse.values.contains(choice.id)
                            )
                        }
                    )
                }
                self.topics = topics
            }
        }

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(BaseTemplateContent(title: "Importer QTI", description: "Import QTI"))
            ) {
                PageTitle(title: "Import QTI Tasks")

                ForEach(in: context.tasks) { task in
                    QTIQuestionPreview(
                        topics: context.topics,
                        question: task
                    )
                }
            }
        }
    }
}

struct QTIQuestion {
    let description: String
    let question: String

    let choices: [MultipleChoiceTaskChoice.Create.Data]

    var choicesWithID: [MultipleChoiceTaskChoice] {
        choices.map { choice in
            MultipleChoiceTaskChoice(
                id: choices.firstIndex(where: { $0.choice == choice.choice }) ?? 0,
                choice: choice.choice,
                isCorrect: choice.isCorrect
            )
        }
    }
}

private struct QTIQuestionPreview: HTMLComponent {

    let topics: TemplateValue<[Topic.WithSubtopics]>
    let question: TemplateValue<QTIQuestion>

    var body: HTML {
        Card {
            SubtopicPicker(label: "Undertema", idPrefix: "subtopic", topics: topics)

            Text { "Beskrivelse" }.style(.cardTitle)
            Text { question.description }

            Text { "Spørsmål" }.style(.cardTitle)
            Text { question.question }

            Text { "Alternativer" }.style(.cardTitle)
            ForEach(in: question.choicesWithID) { choice in
                MultipleChoiceTask.Templates.Create.ChoiseRow(
                    canSelectMultiple: .constant(false),
                    choise: choice
                )
            }

        }
    }
}
