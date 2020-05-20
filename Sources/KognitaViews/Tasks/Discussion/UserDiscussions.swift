import Foundation
import BootstrapKit
import KognitaCore

// A condition that evaluates a greater then expression between a variable and a constant value
public struct GreaterThenTemplates<Value>: Conditionable where Value: Comparable {
  /// The path to the variable
  let lhs: TemplateValue<Value>
  let rhs: TemplateValue<Value>
  public func evaluate<T>(with manager: HTMLRenderer.ContextManager<T>) throws -> Bool {
    try lhs.value(from: manager) > rhs.value(from: manager)
  }
}
extension TemplateValue where Value == Date {
  static func > (lhs: TemplateValue<Value>, rhs: TemplateValue<Value>) -> Conditionable {
    GreaterThenTemplates(lhs: lhs, rhs: rhs)
  }
}

extension TaskDiscussion.Templates {

    public struct UserDiscussions: HTMLTemplate {

        public struct Context {
            let user: User
            let discussions: [TaskDiscussion.Details]

            public init(user: User, discussions: [TaskDiscussion.Details]) {
                self.discussions = discussions
                self.user = user
            }
        }
        

        public var body: HTML {

            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Diskusjoner", description: "Diskusjoner en bruker har laget"))
            ) {


                Text { "Dine diskusjoner" }
                    .style(.heading4)
                    .margin(.four, for: .top)

                Text { "Antall diskusjoner: " + context.discussions.count }

                ForEach(in: context.discussions) { (discussion: TemplateValue<TaskDiscussion.Details>) in
                    Card {
                        Div {
                            Text {
                                discussion.description

                                Unwrap(context.user.viewedNotificationsAt) { (viewedNotificationsAt: TemplateValue<Date>) in
                                    IF(discussion.newestResponseCreatedAt > viewedNotificationsAt) {
                                        Badge{ "new" }
                                            .background(color: .primary)
                                            .margin(.two, for: .left)
                                    }
                                }.else {
                                    Badge{ "new" }.background(color: .primary)
                                }
                            }
                            .style(.heading4)

                            Text {
                                "Laget: " 
                                Unwrap(discussion.createdAt) { (createdAt: TemplateValue<Date>) in
                                    Small { createdAt.style(date: .short, time: .none) }
                                        .margin(.one, for: .left)
                                }
                            }
                        }

                        Button { "Se diskusjon" }
                            .float(.left)
                            .text(color: .dark)
                            .button(style: .light)
                            .button(size: .small)
                            .toggle(modal: .id("response"))
                            .data("dID", value: discussion.id)
                            .data("dUname", value: discussion.username)
                            .data("dDesc", value: discussion.description)
                            .on(click: discussion.fetchResponsesCall)
                    }
                    .margin(.four)
                }

                ShowResponsesModal()
                Stylesheet(url: "/assets/css/vendor/simplemde.min.css")
            }
            .scripts {
                Script(source: "/assets/js/vendor/simplemde.min.js")
                Script(source: "/assets/js/markdown-renderer.js")
                Script().source("/assets/js/task-discussion/fetch-discussions.js")
                Script(source: "/assets/js/vendor/marked.min.js")
            }
        }
    }
}
