// swiftlint:disable multiple_closures_with_trailing_closure

import BootstrapKit
import KognitaCore

extension TaskSolution {
    public enum Templates {}
}

extension TaskSolution.Templates {
    struct Requmendations: HTMLComponent, AttributeNode {

        func copy(with attributes: [HTMLAttribute]) -> TaskSolution.Templates.Requmendations {
            .init(attributes: attributes)
        }

        var attributes: [HTMLAttribute]

        public init() {
            attributes = []
        }

        private init(attributes: [HTMLAttribute]) {
            self.attributes = attributes
        }

        var body: HTML {
            Div {
                Text {
                    "Ditt løsningsforslag har fått en rating på "
                    Span { "0" }.class("solution-rating")
                    " av 10 mulige."
                }
                .style(.heading5)

                Text { "For et godt løsningsforslag: " }
                UnorderedList {
                    ListItem { "Ha et løsningsforslag på ca. 40-150 ord. Dette for å holde løsningsforslaget direktet, men også utdypende nok." }
                    ListItem { "Finn et bildet som kan beskrive løsningen hvis dette er mulig." }
                    ListItem { "Finn en kilde til løsningsforslaget slik at man kan lese mer hvis nødvending. Her anbefales nettresurser for å gjøre det lettere tilgjengelig." }
                    ListItem { "Punktlister eller annen strukturert informasjon anbefales også." }
                }
            }
            .add(attributes: attributes)
        }
    }
}

extension TaskSolution.Response {
    var voteCall: String { "voteOnSolution(\(id), this)" }
    var voteID: String { "solution-\(id)" }
}

extension TaskSolution.Templates {

    public struct List: HTMLTemplate {

        public struct Context {
            let user: User
            let solutions: [TaskSolution.Response]

            var userID: User.ID { user.id ?? 0 }

            public init(user: User, solutions: [TaskSolution.Response]) {
                self.user = user
                self.solutions = solutions
            }
        }

        public var body: HTML {
            Accordions(values: context.solutions, title: { (solution: TemplateValue<TaskSolution.Response>, _: TemplateValue<Int>) in

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
                    Span { solution.numberOfVotes }
                        .id(solution.voteID)
                    " personer"

                    Small {
                        Unwrap(solution.approvedBy) { _ in
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
            }) { (solution: TemplateValue<TaskSolution.Response>, _: TemplateValue<Int>) in

                IF(self.context.userID == solution.creatorID) {
                    MoreDropdown {
                        Anchor { "Rediger" }
                            .toggle(modal: .id("edit-solution"))
                            .data("markdown", value: solution.solution.escaping(.unsafeNone))
                            .data("solutionID", value: solution.id)
                        Anchor { "Slett" }
                            .toggle(modal: .id("delete-solution"))
                            .data("solutionID", value: solution.id)
                    }
                    .float(.right)
                }

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
