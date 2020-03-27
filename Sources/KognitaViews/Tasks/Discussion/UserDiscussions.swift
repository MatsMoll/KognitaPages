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


                Text { "Dine diskusjoner!" }
                    .style(.heading4)
                    .margin(.four, for: .top)

                Text { "Antall diskusjoner: " + context.discussion.count }

                ForEach(in: context.discussion) { (discussion: TemplateValue<TaskDiscussion.Details>) in
                    Card {
                        Text { discussion.description }
                            .style(.heading4)

                        Button { "Se diskusjon!" }
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
            }
            .scripts{
                Script().source("/assets/js/task-discussion/fetch-responses.js")
            }
        }
    }
}
