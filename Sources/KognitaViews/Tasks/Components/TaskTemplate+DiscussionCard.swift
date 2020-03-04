import BootstrapKit
import KognitaCore

extension TaskDiscussion.Details {
    var fetchResponsesCall: String { "fetchDiscussionResponses(\(id))" }
}

extension TaskPreviewTemplate {

    struct DiscussionCard: HTMLComponent {

        let discussions: TemplateValue<[TaskDiscussion.Details]>

        var scripts: HTML {
            NodeList {
                body.scripts
                Script(source: "/assets/js/task-discussion/fetch-responses.js")
            }
        }

        var body: HTML {

            NodeList {
                Card {
                    Text {
                        "Diskusjon"
                    }
                    .style(.heading3)
                }
                .footer {

                    Text {
                        ForEach(in: discussions) { (discussion: TemplateValue<TaskDiscussion.Details>) in

                            Div {
                                Button {
                                    MaterialDesignIcon(.arrowRight)
                                        .text(color: .primary)

                                }
                                .float(.right)
                                .text(color: .dark)
                                .button(style: .light)
                                .button(size: .extraSmall)
                                .margin(.three, for: .left)
                                .toggle(modal: .id("discussion"))
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

                                    }
                                    .display(.flex)
                                    .margin(.three, for: .top)
                                }

                                Small {
                                    "Spurt av: "
                                    discussion.username
                                }
                                .margin(.four, for: .bottom)
                            }
                            .class("border-bottom border-light")
                            .padding(.two, for: .bottom)
                        

                        }
                    }.style(.heading6)
                }

                Card {
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

                Modal(title: "Diskusjon", id: "discussion") {

                    Input().id("disc-id").type(.hidden)

                    Text { "" }.style(.heading3).id("disc-description")

                    Small {
                        "Spurt av: "
                    }
                    .id("disc-username")

                    Div().id("disc-responses").display(.none)


                    FormGroup(label: "Skriv en respons") {
                        TextArea()
                            .id("create-discussion-response")
                            .placeholder("En eller annen respons")
                    }
                    .margin(.four, for: .top)

                    Button {
                        "Svar"
                    }
                    .button(style: .primary)
                    .on(click: "createResponse()")
                }
                .set(data: "dID", to: "disc-id")
                .set(data: "dDesc", to: "disc-description")
                .set(data: "dUname", to: "disc-username")
            }
        }
    }
}
