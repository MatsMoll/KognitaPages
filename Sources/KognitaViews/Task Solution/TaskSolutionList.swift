import BootstrapKit
import KognitaCore

extension TaskSolution {
    public enum Templates {}
}

extension TaskSolution.Templates {
    struct Requmendations: HTMLComponent {
        var body: HTML {
            NodeList {
                Text {
                    "Ditt løsningsforslag har fått en rating på "
                    Span { "0" }.id("solution-rating")
                    " av 10 mulige."
                }
                .style(.heading5)

                Text { "For et godt løsningsforslag: " }
                UnorderedList {
                    ListItem { "Ha et løsningsforslag på ca. 60-150 ord. Dette for å holde løsningsforslaget direktet, men også utdypende nok." }
                    ListItem { "Finn et bildet som kan beskrive løsningen hvis dette er mulig." }
                    ListItem { "Finn en kilde til løsningsforslaget slik at man kan lese mer hvis nødvending. Her anbefales nettresurser for å gjøre det lettere tilgjengelig." }
                    ListItem { "Punktlister eller annen strukturert informasjon anbefales også." }
                }
            }
        }
    }
}

extension TaskSolution.Response {
    var voteCall: String { "voteOnSolution(\(id), this)" }
    var voteID: String { "solution-\(id)" }
}

extension TaskSolution.Templates {

    public struct List: HTMLTemplate {

        public typealias Context = [TaskSolution.Response]

        public var body: HTML {
            Accordions(values: context, title: { (solution: TemplateValue<TaskSolution.Response>, index: TemplateValue<Int>) in

                Text {
                    "Løsningsforslag av "
                    solution.creatorUsername

                    Span {
                        MaterialDesignIcon(.chevronDown)
                            .class("accordion-arrow")
                    }
                    .float(.right)
                }
                .style(.heading4)

                Text {
                    "Nytting for "
                    Span {
                        solution.numberOfVotes
                    }
                    .id(solution.voteID)
                    " personer"

                    Small {
                        Unwrap(solution.approvedBy) { approvedBy in
                            Badge {
                                "Verifisert"
                                MaterialDesignIcon(icon: .check)
                            }
                            .background(color: .success)
                            .margin(.two, for: .left)
                        }.else {
                            Badge {
                                "Ikke verifisert enda"
                            }
                            .background(color: .warning)
                            .margin(.two, for: .left)
                        }
                    }
                }
            }) { (solution: TemplateValue<TaskSolution.Response>, index: TemplateValue<Int>) in
                Div {
                    solution.solution
                        .escaping(.unsafeNone)
                }
                .class("solutions")
                Small {
                    "Var løsningsforslaget nyttig?"
                    Button {
                        IF(solution.userHasVoted) {
                            MaterialDesignIcon(.heart)
                                .class("vote-button")
                                .text(color: .danger)
                        }.else {
                            MaterialDesignIcon(.heartOutline)
                                .class("vote-button")
                        }
                    }
                    .on(click: solution.voteCall)
                    .button(style: .light)
                    .margin(.two, for: .left)
                }
            }
            .footer {
                Text { "Vil du skrive ditt eget løsningsforslag?" }

                Button { "Foreslå et løsningsforslag" }
                    .toggle(modal: .id("create-alternative-solution"))
                    .button(style: .light)
            }
        }

        struct SolutionCard: HTMLComponent {

            let context: TemplateValue<TaskSolution.Response>

            var body: HTML {
                Card {
                    Div {
                        Div {
                            Text(Strings.exerciseProposedSolutionTitle)
                                .style(.heading4)
                        }
                        .class("page-title")
                        Div {
                            IF(context.creatorUsername.isDefined) {
                                "Laget av: "
                                context.creatorUsername
                            }
                            IF(context.approvedBy.isDefined) {
                                Badge {
                                    "Verifisert av: "
                                    context.approvedBy
                                }
                                .background(color: .success)
                                .margin(.two, for: .left)
                            }.else {
                                Badge { "Ikke verifisert enda" }
                                    .background(color: .warning)
                                    .margin(.two, for: .left)
                            }
                        }
                    }
                    .class("page-title-box")
                    .margin(.two, for: .bottom)

                    context.solution.escaping(.unsafeNone)
                }
            }
        }
    }
}
