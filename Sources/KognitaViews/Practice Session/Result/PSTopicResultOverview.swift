import BootstrapKit
import KognitaCore
import Foundation

struct CollapsingCard: HTMLComponent, AttributeNode {

    let id: HTML
    let header: HTML
    let content: AddableAttributeNode
    let isShown: Conditionable

    var attributes: [HTMLAttribute]

    var body: HTML {
        Div {
            Anchor {
                Span {
                    Italic().class("mdi mdi-chevron-down accordion-arrow")
                }
                .float(.right)

                header
            }
            .class("card-body")
            .data(for: "toggle", value: "collapse")
            .data(for: "target", value: "#" + id)
            .aria(for: "controls", value: id)

            content
                .class("collapse" + IF(isShown) { " show" })
                .id(id)
        }
        .class("card")
        .add(attributes: attributes)
    }

    init(@HTMLBuilder header: () -> HTML) {
        self.id = "CollapsingCard"
        self.header = header()
        self.content = Div()
        self.isShown = false
        attributes = []
    }

    init(id: HTML, header: HTML, content: AddableAttributeNode, isShown: Conditionable, attributes: [HTMLAttribute]) {
        self.id = id
        self.header = header
        self.content = content
        self.isShown = isShown
        self.attributes = attributes
    }

    func copy(with attributes: [HTMLAttribute]) -> CollapsingCard {
        .init(id: id, header: header, content: content, isShown: isShown, attributes: attributes)
    }

    func content(content: () -> AddableAttributeNode) -> CollapsingCard {
        .init(id: id, header: header, content: content(), isShown: isShown, attributes: attributes)
    }

    func collapseId(_ id: HTML) -> CollapsingCard {
        .init(id: id, header: header, content: content, isShown: isShown, attributes: attributes)
    }

    func isShown(_ condition: Conditionable) -> CollapsingCard {
        .init(id: id, header: header, content: content, isShown: condition, attributes: attributes)
    }
}

extension PracticeSession.Templates.Result {

    struct TopicOverview<T>: HTMLComponent, AttributeNode {

        let topicId: TemplateValue<T, Topic.ID>
        let topicName: TemplateValue<T, String>
        let topicLevel: TemplateValue<T, Double>
        let topicTaskResults: TemplateValue<T, [TaskResultable]>

        var isShown: Conditionable = false
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
            .isShown(isShown)
            .add(attributes: attributes)
        }

        func copy(with attributes: [HTMLAttribute]) -> PracticeSession.Templates.Result.TopicOverview<T> {
            .init(topicId: topicId, topicName: topicName, topicLevel: topicLevel, topicTaskResults: topicTaskResults, isShown: isShown, attributes: attributes)
        }

        func isShown(_ isShown: Conditionable) -> PracticeSession.Templates.Result.TopicOverview<T> {
            .init(topicId: topicId, topicName: topicName, topicLevel: topicLevel, topicTaskResults: topicTaskResults, isShown: isShown, attributes: attributes)
        }
    }
}
