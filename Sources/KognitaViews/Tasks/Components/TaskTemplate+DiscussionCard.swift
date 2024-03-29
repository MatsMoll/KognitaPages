import BootstrapKit
import Foundation

extension TaskDiscussion {
    var fetchResponsesCall: String { "fetchDiscussionResponses(\(id))" }
}

extension TaskDiscussion {
    public enum Templates {}
}

extension TaskDiscussion.Templates {

    struct CreateModal: HTMLComponent {

        var body: HTML {
            Modal(title: "Diskusjon", id: "discussion-modal") {

                FormGroup(label: "Noe du lurer på?") {
                    TextArea()
                        .id("create-discussion-question")
                        .placeholder("Hva lurer du på?")
                }

                Button {
                    "Still et spørsmål"
                }
                .on(click: "createDiscussion()")
                .button(style: .primary)
            }
        }
    }
}

extension TaskDiscussion.Templates {

    struct ShowResponsesModal: HTMLComponent {

        var scripts: HTML {
            NodeList {
                body.scripts
                Script().source("/assets/js/task-discussion/fetch-responses.js")
                Script(source: "/assets/js/task-discussion/create-response.js")
            }
        }

        var body: HTML {
            Modal(title: "Svar", id: "response") {

                Input().id("disc-id").type(.hidden)

                Text { "" }.style(.heading3).id("disc-description")

                Small {
                    "Spurt av: "
                }
                .id("disc-username")

                Div().id("disc-responses").display(.none)

                FormGroup(label: "Skriv en respons") {
                    MarkdownEditor(id: "create-discussion-response")
                        .placeholder("En eller annen respons")
                }
                .margin(.four, for: .top)

                Button {
                    "Svar"
                }
                .button(style: .primary)
                .on(click: "createResponse()")
            }
            .text(break: .break)
            .set(data: "dID", type: .input, to: "disc-id")
            .set(data: "dDesc", type: .textArea, to: "disc-description")
            .set(data: "dUname", type: .node, to: "disc-username")
        }
    }
}

extension TaskDiscussion.Templates {

    public struct DiscussionCard: HTMLTemplate {

        public typealias Context = [TaskDiscussion]

        public var scripts: HTML {
            htmlBody.scripts
        }

        var htmlBody: HTML {
            NodeList {
                Card {
                    Text { "Diskusjon" }
                        .style(.heading4)
                }
                .footer {

                    Div {
                        IF(context.isEmpty) {
                            Text { "Det finnes ingen diskusjoner ennå! Om det er noe du lurer på er det bare å spørre!" }
                        }
                        .else {
                            ForEach(in: context) { (discussion: TemplateValue<TaskDiscussion>) in
                                Div {
                                    Button {
                                        MaterialDesignIcon(.arrowRight)

                                    }
                                    .float(.right)
                                    .text(color: .dark)
                                    .button(style: .light)
                                    .button(size: .extraSmall)
                                    .margin(.three, for: .left)
                                    .toggle(modal: .id("response"))
                                    .data("dID", value: discussion.id)
                                    .data("dUname", value: discussion.username)
                                    .data("dDesc", value: discussion.description)
                                    .on(click: discussion.fetchResponsesCall)

                                    Div {
                                        Div {
                                            Text {
                                                discussion.description
                                            }
                                            .style(.heading4)
                                            .margin(.zero, for: .top)
                                        }
                                        .display(.flex)
                                    }

                                    Small {
                                        "Forfatter: "
                                        discussion.username
                                    }
                                }
                                .class("border-bottom border-light")
                                .padding(.two, for: .bottom)
                                .padding(.two, for: .top)
                            }
                        }

                        Button { "Lag diskusjon" }
                            .toggle(modal: .id("discussion-modal"))
                            .margin(.two, for: .top)
                            .button(style: .light)
                    }
                    .margin(.zero, for: .top)
                }
                .text(break: .break)

                ShowResponsesModal()
            }
        }

        public var body: HTML {
            NodeList {
                htmlBody
                scripts
            }
        }
    }
}
