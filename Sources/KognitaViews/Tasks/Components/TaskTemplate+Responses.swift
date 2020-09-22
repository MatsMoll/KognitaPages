import BootstrapKit
import Foundation

public enum TextBreak: String {
    case wrap
    case noWrap = "nowrap"
    case `break`
    case truncate
}

extension GlobalAttributes {
    func text(break textBreak: TextBreak) -> Self {
        self.class("text-\(textBreak.rawValue)")
    }
}

public extension TaskPreviewTemplate {

    struct Responses: HTMLTemplate {

        public struct Context {
            public let responses: [TaskDiscussionResponse]

            public init(responses: [TaskDiscussionResponse]) {
                self.responses = responses
            }
        }

        public var body: HTML {
            Div {
                Text {
                    context.responses.count
                    " svar:"
                }
                .margin(.two, for: .top)
                .margin(.two, for: .bottom)
                .class("border-bottom border-light")

                ForEach(in: context.responses) { (response: TemplateValue<TaskDiscussionResponse>) in
                    DiscussionResponse(response: response)

                    IF(response.isNew) {
                        Span { "New " }.class("badge badge-primary")
                    }
                }
            }
        }
    }
}
