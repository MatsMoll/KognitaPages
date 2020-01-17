import BootstrapKit
import KognitaCore

extension Subject.Templates {
    struct CreateContentModal: HTMLComponent {

        let subject: TemplateValue<Subject>

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
                                    "Usikker på hva som finnes?"
                                }
                                .style(.heading4)
                                .text(color: .dark)

                                Anchor {
                                    "Se mer"
                                }
                                .href("/creator/subjects/" + subject.id + "/overview")
                                .button(style: .light)
                                .class("btn-rounded")
                                .float(.right)
                                .margin(.three, for: .left)

                                Text {
                                    "Gå inn på et tema og se hva som allerede finnes."
                                }



                                Text {
                                    "Lag et tema"
                                }
                                .style(.heading4)
                                .text(color: .dark)
                                .margin(.four, for: .top)

                                Anchor {
                                    "Lag tema"
                                }
                                .href("/creator/subjects/" + subject.id + "/topics/create")
                                .button(style: .light)
                                .class("btn-rounded")
                                .float(.right)
                                .margin(.three, for: .left)

                                Text {
                                    "Her kan du dele faget inn i flere deler og dermed få en bedre oversikt over studentens kompetanse"
                                }



                                Text {
                                    "Lag flervalgsoppgave"
                                }
                                .style(.heading4)
                                .text(color: .dark)
                                .margin(.four, for: .top)

                                Anchor {
                                    "Lag oppgave"
                                }
                                .href("/creator/subjects/" + subject.id + "/task/multiple/create")
                                .button(style: .light)
                                .class("btn-rounded")
                                .float(.right)
                                .margin(.three, for: .left)

                                Text {
                                    "Dette passer bra for automatisk testing, men også for å teste grunnleggende teori som ikke inneholder mellomregning."
                                }



                                Text {
                                    "Lag innskrivingsoppgave"
                                }
                                .style(.heading4)
                                .text(color: .dark)
                                .margin(.four, for: .top)

                                Anchor {
                                    "Lag oppgave"
                                }
                                .href("/creator/subjects/" + subject.id + "/task/flash-card/create")
                                .button(style: .light)
                                .class("btn-rounded")
                                .float(.right)
                                .margin(.three, for: .left)

                                Text {
                                    "Dette passer bra for å terpe og for å lære ny kunnskap ettersom besvarelsesmetoden er mer krevende. Det passer også for oppgaver med en del begrunnelse."
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
