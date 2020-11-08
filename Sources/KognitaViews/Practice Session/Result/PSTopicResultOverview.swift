import BootstrapKit

extension Sessions.Templates {
    enum Result {}
}

extension Sessions.Templates.Result {

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
                        TaskCell(result: result)
                    }
                }
                .class("list-group list-group-flush")
            }
            .collapseId("collapse" + topicId)
            .isShown(isShownValue)
            .add(attributes: attributes)
        }

        func copy(with attributes: [HTMLAttribute]) -> Sessions.Templates.Result.TopicOverview {
            .init(topicId: topicId, topicName: topicName, topicLevel: topicLevel, topicTaskResults: topicTaskResults, isShownValue: isShownValue, attributes: attributes)
        }

        func isShown(_ condition: Conditionable) -> Sessions.Templates.Result.TopicOverview {
            .init(topicId: topicId, topicName: topicName, topicLevel: topicLevel, topicTaskResults: topicTaskResults, isShownValue: condition, attributes: attributes)
        }
    }
}

private struct TaskCell: HTMLComponent {

    let result: TemplateValue<TaskResultable>

    var body: HTML {
        Div {
            Anchor {
                KognitaProgressBadge(value: result.resultScore.twoDecimals)

                Text { result.question }
                    .text(color: .secondary)
                    .margin(.three, for: .right)
                    .margin(.one, for: .bottom)
            }
            .href(result.executedTaskUri)
        }
        .class("list-group-item")
    }
}

extension TaskResultable {
    var executedTaskUri: String {
        "tasks/\(taskIndex)"
    }
}

extension Double {
    var twoDecimals: Double {
        (self * 100).rounded() / 100
    }

    var timesHundred: Double {
        self * 100
    }
}
