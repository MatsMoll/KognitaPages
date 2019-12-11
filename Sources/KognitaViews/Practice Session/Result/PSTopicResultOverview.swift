import BootstrapKit
import KognitaCore

extension PracticeSession.Templates.Result {

    struct TopicOverview<T>: HTMLComponent, AttributeNode {

        let topicName: TemplateValue<T, String>
        let topicLevel: TemplateValue<T, Double>
        let topicTaskResults: TemplateValue<T, [TaskResultable]>
        var attributes: [HTMLAttribute] = []

        var body: HTML {
            Card {
                Text {
                    topicName
                }
                .style(.heading3)
                .text(color: .dark)

                KognitaProgressBar(
                    value: topicLevel
                )
            }.sub {
                Div {
                    ForEach(in: topicTaskResults) { (result: RootValue<TaskResultable>) in
                        Div {
                            KognitaProgressBadge(
                                value: result.resultScore
                            )

                            Text {
                                result.question
                            }
                            .text(color: .muted)
                            .margin(.three, for: .right)
                            .margin(.one, for: .bottom)
                        }
                        .class("list-group-item")
                    }
                }
                .class("list-group list-group-flush")
            }
            .add(attributes: attributes)
        }

        func copy(with attributes: [HTMLAttribute]) -> PracticeSession.Templates.Result.TopicOverview<T> {
            .init(topicName: topicName, topicLevel: topicLevel, topicTaskResults: topicTaskResults, attributes: attributes)
        }
    }
}
