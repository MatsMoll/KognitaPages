import BootstrapKit
import KognitaCore
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
            public let responses: [TaskDiscussion.Pivot.Response.Details]

            public init(responses: [TaskDiscussion.Pivot.Response.Details]) {
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

                ForEach(in: context.responses) { (response: TemplateValue<TaskDiscussion.Pivot.Response.Details>) in
                    DiscussionResponse(response: response)

                    IF(response.isNew) {
                        Span { "New " }.class("badge badge-primary")
                    }
                }
            }
        }
    }
}
