import BootstrapKit
import KognitaCore

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

extension TaskPreviewTemplate {

    public struct Responses: HTMLTemplate {

        public typealias Context = [TaskDiscussion.Pivot.Response.Details]

        public var body: HTML {
            Div {
                Text {
                    context.count
                    " svar:"
                }
                .margin(.two, for: .top)
                .margin(.two, for: .bottom)
                .class("border-bottom border-light")

                ForEach(in: context) { (response: TemplateValue<TaskDiscussion.Pivot.Response.Details>) in
                    DiscussionResponse(response: response)
                }
            }
        }
    }
}
