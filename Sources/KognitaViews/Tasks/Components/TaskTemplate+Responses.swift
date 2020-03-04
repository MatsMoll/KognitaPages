import BootstrapKit
import KognitaCore


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

                    Div {
                        MaterialDesignIcon(.accountCircle)
                            .float(.left)
                            .style(css: "font-size: 40px;")
                            .margin(.two, for: .right)

                        Div {

                            Div {
                                Text {
                                    response.username
                                }
                                .style(.heading5)
                                .margin(.zero, for: .top)

                                Text {
                                    response.response
                                }
                                .style(.lead)
                                .margin(.one, for: .bottom)
                                .padding(.two, for: .bottom)
                            }
                        }
                        .display(.flex)
                        .margin(.two, for: .top)
                    }
                    .class("border-bottom border-light")
                }
            }
        }
    }
}
