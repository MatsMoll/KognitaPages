import BootstrapKit
import KognitaCore


extension TaskPreviewTemplate {

    struct DiscussionCard: HTMLComponent {

        let discussions: TemplateValue<[TaskDiscussion.Details]>

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
                                    MaterialDesignIcon(.arrowRight).background(color: .primary)

                                }
                                .float(.right)
                                .text(color: .dark)
                                .button(style: .light)
                                .button(size: .extraSmall)
                                .margin(.three, for: .left)
                                .toggle(modal: .id("fuck-you"))

                                Modal(title: "Morn", id: "fuck-you") {

                                    Text {
                                        discussion.description
                                    }
                                    .style(.heading3)

                                    Small {
                                        "Spurt av: "
                                        discussion.username
                                    }

                                    Text {
                                        "Reponses:"
                                    }
                                    .margin(.two, for: .top)

                                    ForEach(in: discussion.responses) { response in
                                        Text {
                                            response.response
                                        }
                                    }

                                    FormGroup(label: "Skriv en respons") {
                                        TextArea()
                                            .id("#create-discussion-response")
                                            .placeholder("En eller annen respons")
                                    }

                                    Button {
                                        "Svar"
                                    }
                                    .button(style: .primary)
                                    .on(click: "createResponse()")
                                }

                                Text {
                                    discussion.description
                                }
                                .style(.heading4)

                                Small {
                                    "Spurt av: "
                                    discussion.username
                                }
                                .margin(.three, for: .bottom)
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
            }
        }
    }
}
