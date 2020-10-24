import BootstrapKit

extension RecommendedRecap {
    var recapCall: String { "startPracticeSessionWithTopicIDs([\(topicID)],\(subjectID))" }
}

extension Subject.Templates.ListOverview {

    struct RecommendedRecapCard: HTMLComponent {

        let recap: TemplateValue<RecommendedRecap>

        var body: HTML {
            Card {

                Text {
                    "Basert på aktiviteten din anbefaler vi å repitere "
                    recap.topicName
                    " innen "
                    recap.revisitAt.style(date: .short, time: .none)
                }
                .text(color: .dark)

                Button {
                    MaterialDesignIcon(.loop)
                        .margin(.one, for: .right)
                    "Repiter nå"
                }
                .button(style: .primary)
                .on(click: recap.recapCall)
                .isRounded()
            }
            .header {
                Text {
                    MaterialDesignIcon(.loop)
                        .margin(.one, for: .right)
                    "Repiter "
                    recap.topicName
                }
                .style(.heading3)
                .text(color: .white)

                Badge { recap.subjectName }
                    .background(color: .light)
            }
            .modifyHeader { $0.background(color: .primary) }
        }

        var scripts: HTML {
            NodeList {
                body.scripts
                Script().source("/assets/js/practice-session-create.js")
            }
        }
    }

    struct ContinuePracticeSessionCard: HTMLComponent {

        let ongoingSessionPath: TemplateValue<String?>

        var body: HTML {
            Unwrap(ongoingSessionPath) { path in
                Row {
                    Div {
                        Card {
                            Text {
                                "Fullfør treningssesjonen"
                            }
                            .style(.heading3)
                            .class("mt-0")
                            Text { "Du har en treningssesjon som ikke er fullført. Sett av litt tid og fullfør." }
                            Anchor {
                                Button {
                                    Italic().class("mdi mdi-book-open-variant")
                                    " Fortsett"
                                }
                                .type(.button)
                                .class("btn-rounded mb-1")
                                .button(style: .primary)
                            }
                            .href(path)
                            .text(color: .dark)
                        }
                        .display(.block)
                    }
                    .column(width: .twelve)
                }
            }
        }
    }
}
