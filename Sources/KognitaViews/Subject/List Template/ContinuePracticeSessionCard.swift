
import BootstrapKit
import KognitaCore

extension Subject.Templates.ListOverview {

    struct ContinuePracticeSessionCard<T>: HTMLComponent {

        let ongoingSessionPath: TemplateValue<T, String?>

        var body: HTML {
            Unwrap(value: ongoingSessionPath) { path in
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
