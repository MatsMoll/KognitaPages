import BootstrapKit

extension Subject.Templates.ListOverview {

    struct RecommendedRecapCard: HTMLComponent {

        let recap: TemplateValue<RecommendedRecap>

        var body: HTML {
            Card {

                Text {
                    "Basert på aktiviteten din anbefaler vi å repitere "
                    Italic { recap.topicName }
                    " innen "
                    Italic { recap.subjectName }
                    " før "
                    recap.revisitAt.style(date: .short, time: .none)
                }
                .text(color: .dark)

                PracticeSession.Templates.CreateModal.button(
                    subjectID: recap.subjectID,
                    topicID: recap.topicID,
                    topicDescription: recap.topicName
                ) {
                    MaterialDesignIcon(.loop)
                        .margin(.one, for: .right)
                    "Repiter nå"
                }
                .button(style: .primary)
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
            }
            .modifyHeader { $0.background(color: .primary) }
            .footer {
                Div {
                    Text {
                        recap.resultScore.timesHundred.twoDecimals
                        "%"
                        Small { recap.topicName }
                            .margin(.one, for: .left)
                    }
                    .style(.paragraph)
                    .font(style: .bold)
                    .margin(.two, for: .bottom)

                    KognitaProgressBar(value: recap.resultScore.timesHundred)
                }
                .margin(.two, for: .vertical)
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
