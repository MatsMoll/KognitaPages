import Foundation
import BootstrapKit
import KognitaCore



extension TaskDiscussion.Templates {

    public struct UserDiscussions: HTMLTemplate {

        public struct Context {
            let user: User
            let discussion: [TaskDiscussion.Details]

            public init(user: User, discussion: [TaskDiscussion.Details]) {
                self.discussion = discussion
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

                Text { "Antall diskusjoner: " + context.discussion.count }

                ForEach(in: context.discussion) { (discussion: TemplateValue<TaskDiscussion.Details>) in
                    Card {
                        Div {
                            Text { discussion.description }
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
