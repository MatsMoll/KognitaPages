import BootstrapKit
import KognitaCore

extension PracticeSession.Templates.Result {

    struct TopicOverview: HTMLComponent, AttributeNode {

        let topicId: TemplateValue<Topic.ID>
        let topicName: TemplateValue<String>
        let topicLevel: TemplateValue<Double>
        let topicTaskResults: TemplateValue<[TaskResultable]>

        init(topicId: TemplateValue<Topic.ID>, topicName: TemplateValue<String>, topicLevel: TemplateValue<Double>, topicTaskResults: TemplateValue<[TaskResultable]>) {
            self.topicId = topicId
            self.topicName = topicName
            self.topicLevel = topicLevel
            self.topicTaskResults = topicTaskResults
        }

        init(topicId: TemplateValue<Topic.ID>, topicName: TemplateValue<String>, topicLevel: TemplateValue<Double>, topicTaskResults: TemplateValue<[TaskResultable]>, isShownValue: Conditionable, attributes: [HTMLAttribute]) {
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
                    topicLevel.twoDecimals + "%"
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
                    ForEach(in: topicTaskResults) { (result: TemplateValue<TaskResultable>) in
                        Div {

                            KognitaProgressBadge(
                                value: result.resultScore.twoDecimals
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

        func copy(with attributes: [HTMLAttribute]) -> PracticeSession.Templates.Result.TopicOverview {
            .init(topicId: topicId, topicName: topicName, topicLevel: topicLevel, topicTaskResults: topicTaskResults, isShownValue: isShownValue, attributes: attributes)
        }

        func isShown(_ condition: Conditionable) -> PracticeSession.Templates.Result.TopicOverview {
            .init(topicId: topicId, topicName: topicName, topicLevel: topicLevel, topicTaskResults: topicTaskResults, isShownValue: condition, attributes: attributes)
        }
    }
}

extension Double {
    fileprivate var twoDecimals: Double {
        (self * 100).rounded() / 100
    }
}
