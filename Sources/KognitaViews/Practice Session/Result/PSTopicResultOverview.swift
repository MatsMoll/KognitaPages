import BootstrapKit
import KognitaCore

extension PracticeSession.Templates.Result {

    struct TopicOverview<T>: HTMLComponent, AttributeNode {

        let topicId: TemplateValue<T, Topic.ID>
        let topicName: TemplateValue<T, String>
        let topicLevel: TemplateValue<T, Double>
        let topicTaskResults: TemplateValue<T, [TaskResultable]>

        init(topicId: TemplateValue<T, Topic.ID>, topicName: TemplateValue<T, String>, topicLevel: TemplateValue<T, Double>, topicTaskResults: TemplateValue<T, [TaskResultable]>) {
            self.topicId = topicId
            self.topicName = topicName
            self.topicLevel = topicLevel
            self.topicTaskResults = topicTaskResults
        }

        init(topicId: TemplateValue<T, Topic.ID>, topicName: TemplateValue<T, String>, topicLevel: TemplateValue<T, Double>, topicTaskResults: TemplateValue<T, [TaskResultable]>, isShownValue: Conditionable, attributes: [HTMLAttribute]) {
            self.topicId = topicId
            self.topicName = topicName
            self.topicLevel = topicLevel
            self.topicTaskResults = topicTaskResults
            self.isShownValue = isShownValue
            self.attributes = attributes
        }

        private var isShownValue: Conditionable = false
        var attributes: [HTMLAttribute] = []

        var body: HTML {
            CollapsingCard {
                Text {
                    topicName
                }
                .style(.heading3)
                .text(color: .secondary)
                .margin(.zero, for: .top)

                Text {
                    topicLevel + "%"
                    Small { topicTaskResults.count + " oppgaver" }
                        .margin(.one, for: .left)

                }
                .font(style: .bold)
                .margin(.two, for: .bottom)
                .text(color: .secondary)

                KognitaProgressBar(
                    value: topicLevel
                )
            }
            .content {
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
            .collapseId("collapse" + topicId)
            .isShown(isShownValue)
            .add(attributes: attributes)
        }

        func copy(with attributes: [HTMLAttribute]) -> PracticeSession.Templates.Result.TopicOverview<T> {
            .init(topicId: topicId, topicName: topicName, topicLevel: topicLevel, topicTaskResults: topicTaskResults, isShownValue: isShownValue, attributes: attributes)
        }

        func isShown(_ isShown: Conditionable) -> PracticeSession.Templates.Result.TopicOverview<T> {
            .init(topicId: topicId, topicName: topicName, topicLevel: topicLevel, topicTaskResults: topicTaskResults, isShownValue: isShownValue, attributes: attributes)
        }
    }
}
