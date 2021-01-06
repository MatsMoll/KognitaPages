// swiftlint:disable multiple_closures_with_trailing_closure

import BootstrapKit

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
                    ListItem { "Ha et løsningsforslag på ca. 40-150 ord. Dette sørger for å holde løsningsforslaget direkte samtidig som det er utdypende nok." }
                    ListItem { "Legg til et bilde som kan beskrive løsningen hvis det er mulig." }
                    ListItem { "Legg ved en kilde til løsningsforslaget slik at man kan lese mer hvis nødvending. Vi anbefaler nettresurser for å gjøre fagstoffet lettere tilgjengelig." }
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

extension Resource {
    var viewModel: ResourceViewModel {
        switch self {
        case .article(let article):
            return ResourceViewModel(
                icon: .fileDocument,
                url: .init(url: article.url, callToAction: "Les artikkel"),
                title: article.title,
                secondaryTitle: article.author
            )
        case .book(let book):
            return ResourceViewModel(
                icon: .openBook,
                url: nil,
                title: book.title,
                secondaryTitle: "Side \(book.startPageNumber)-\(book.endPageNumber)",
                tetriaryTitle: book.bookTitle,
                quartileTitle: book.author
            )
        case .video(let video):
            var durationString: String? = nil
            if let duration = video.duration {
                durationString = "\(duration) sek"
            }
            return ResourceViewModel(
                icon: .video,
                url: .init(url: video.url, callToAction: "Se video"),
                title: video.title,
                secondaryTitle: video.creator,
                tetriaryTitle: durationString
            )
        }
    }
}

extension TaskSolution.Templates {

    public struct List: HTMLTemplate {

        public struct Context {
            let user: User
            let solutions: [TaskSolution.Response]
            let resources: [ResourceViewModel]

            var userID: User.ID { user.id }

            public init(user: User, solutionResources: TaskSolution.Resources) {
                self.user = user
                self.solutions = solutionResources.solutions
                self.resources = solutionResources.resources.map { $0.viewModel }
            }
        }

        public var body: HTML {
            NodeList {
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
                                Badge { "Ikke verifisert enda" }
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
                
                IF(context.resources.isEmpty == false) {
                    ResourceList(resources: context.resources)
                }
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
