import BootstrapKit
import KognitaCore

extension Subject.Templates {
    struct CreateContentModal<T>: HTMLComponent {

        let subject: TemplateValue<T, Subject>

        var body: HTML {
            Div {
                Div {
                    Div {
                        Div {
                            H4 {
                                "Lag innhold"
                            }
                            .class("modal-title")
                            .id("practice-modal-label")

                            Button {
                                "×"
                            }
                            .type("button")
                            .class("close")
                            .data(for: "dismiss", value: "modal")
                            .aria(for: "hidden", value: "true")
                        }
                        .class("modal-header bg-light")

                        Div {
                            Div {
                                Text {
                                    "Lag flervalgsoppgave"
                                }
                                .style(.heading4)
                                .text(color: .dark)

                                Anchor {
                                    "Lag oppgave"
                                }
                                .href("/creator/subjects/" + subject.id + "/task/multiple/create")
                                .button(style: .light)
                                .class("btn-rounded")
                                .float(.right)
                                .margin(.three, for: .left)

                                Text {
                                    "Dette passer bra for automatisk testing, men også bra for å teste grunnleggende teori, som ikke inneholder mye begrunnelse eller utregning."
                                }

                                Text {
                                    "Lag innskrivingsoppgave"
                                }
                                .style(.heading4)
                                .text(color: .dark)

                                Anchor {
                                    "Lag oppgave"
                                }
                                .href("/creator/subjects/" + subject.id + "/task/flash-card/create")
                                .button(style: .light)
                                .class("btn-rounded")
                                .float(.right)
                                .margin(.three, for: .left)

                                Text {
                                    "Dette passer bra for å terpe og lære ny kunnskap, ettersom disse er litt vanskeligere. Det passer også for oppgaver med en god del begrunnelse."
                                }
                            }
                            .class("p-2")
                        }
                        .class("modal-body")
                    }
                    .class("modal-content")
                }
                .class("modal-dialog modal-dialog-centered modal-lg")
            }
            .class("modal fade")
            .id("create-content-modal")
            .role("dialog")
            .aria(for: "labelledby", value: "create-content-modal")
            .aria(for: "hidden", value: "true")

        }
    }
}
