import BootstrapKit
import KognitaCore

extension TaskSolution {
    public enum Templates {}
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
                .style(.heading3)

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
            }) { (solution, index) in
                Div {
                    solution.solution
                        .escaping(.unsafeNone)

                    Text {
                        "Var løsningsforslaget nyttig? Trykk på knappen og si om det hjalp"

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
                    .style(.heading5)
                }
                .class("solutions")
            }
            .footer {
                Text {
                    "Løst det på en annen måte?"
                }
                .style(.heading4)

                Text {
                    "Foreslå et annet løsningsforslag"
                }
                FormGroup(label: "Løsningsforslag") {
                    TextArea().id("new-solution")
                }
                Button {
                    "Foreslå løsningsforslag"
                }
                .on(click: "")
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
                                "Laget av: " + context.creatorUsername
                            }
                            IF(context.approvedBy.isDefined) {
                                Badge {
                                    "Verifisert av: " + context.approvedBy
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
                    .class("page-title-box")
                    .margin(.two, for: .bottom)

                    context.solution.escaping(.unsafeNone)
                }
            }
        }
    }
}
