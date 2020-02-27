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
                            Text {
                                discussion.username
                            }

                            Text {
                                discussion.description
                            }

                        }
                    }
                    .style(.heading6)
                }
                
                Card {
                    FormGroup(label: "Noe du lurer på?") {
                        TextArea()
                            .id("create-discussion-question")
                    }

                    Button {
                        "Lag spørsmål"
                    }
                    .on(click: "createDiscussion()")
                    .button(style: .primary)
                }
            }
        }
    }
}
