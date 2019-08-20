//
//  SubjectListTemplate.swift
//  App
//
//  Created by Mats Mollestad on 26/02/2019.
//
// swiftlint:disable line_length nesting

import Foundation
import HTMLKit
import KognitaCore

public struct SubjectListTemplate: LocalizedTemplate {

    public init() {}

    // Static so it can be referanceed in the base template
    static let title = "Tema liste"

    public static var localePath: KeyPath<SubjectListTemplate.Context, String>? = \.locale

    public enum LocalizationKeys: String {
        case repeatTitle = "subjects.repeat.title"

        case title = "subjects.title"
        case listTitle = "subjects.list.title"
        case noContent = "subjects.no.content"

    }

    public struct Context {
        let locale = "nb"
        let base: ContentBaseTemplate.Context
        let cards: [Subject]
        let revisitTasks: [TopicResultContent]
        let ongoingSessionPath: String?

        public init(user: User, cards: [Subject], revisitTasks: [TopicResultContent], ongoingSessionPath: String?) {
            self.base = .init(user: user, title: SubjectListTemplate.title)
            self.cards = cards
            self.revisitTasks = revisitTasks
            self.ongoingSessionPath = ongoingSessionPath
        }
    }

    public func build() -> CompiledTemplate {
        return embed(
            ContentBaseTemplate(
                body:

                div.class("row").child(
                    div.class("col-12").child(
                        div.class("page-title-box").child(
                            div.class("page-title-right").child(
                                ol.class("breadcrumb m-0").child(
                                    li.class("breadcrumb-item active").child(
                                        localize(.title)
                                    )
                                )
                            )
                        )
                    )
                ),

                renderIf(
                    isNotNil: \.ongoingSessionPath,

                    h3.child(
                        "Fortsett"
                    ),

                    div.class("row").child(
                        div.class("col-md-6 col-xl-6").child(
                            div.class("card d-block").child(
                                div.class("card-body").child(

                                    // Title
                                    h3.class("mt-0").child(
                                        "Fullfør treningssesjonen"
                                    ),

                                    p.child(
                                        "Du har en treningssesjon som ikke er fullført. Sett av litt tid og fullfør."
                                    ),

                                    a.href(variable(\.ongoingSessionPath)).class("text-dark").child(
                                        button.type("button").class("btn btn-primary btn-rounded mb-1").child(
                                            i.class("mdi mdi-book-open-variant"),
                                            " Fortsett"
                                        )
                                    )
                                )
                            )
                        )
                    )
                ),

                renderIf(
                    \.revisitTasks.count > 0,

                    h3.child(
                        localize(.repeatTitle)
                    ),

                    div.class("row").child(

                        forEach(
                            in: \.revisitTasks,
                            render: RevisitCard()
                        )
                    )
                ),

                h3.child(
                    localize(.listTitle)
                ),

                div.class("row").child(
                    renderIf(
                        \.cards.count > 0,

                        forEach(
                            in:     \.cards,
                            render: Card()
                        )
                    ).else(
                        h1.child(
                            localize(.noContent)
                        )
                    )
                ),

                scripts:
                script.src("/assets/js/practice-session-create.js")
            ),
            withPath: \.base)
    }

    // MARK: - Subview

    struct Card: LocalizedTemplate {

        static var localePath: KeyPath<Subject, String>?

        enum LocalizationKeys: String {
            case button = "subjects.subject.card.button"
        }

        typealias Context = Subject

        func build() -> CompiledTemplate {
            return
                div.class("col-md-6 col-xl-6").child(
                    a.href("subjects/", variable(\.id)).class("text-dark").child(
                        div.class("card d-block").child(

                            // Thumbnail
                            div.class("card-header text-white bg-" + variable(\.colorClass)).child(
                                h3.child(
                                    variable(\.name)
                                ),
                                small.class("badge badge-light").child(
                                    variable(\.category)
                                )
                            ),
                            div.class("card-body position-relative").child(

                                p.child(
                                    variable(\.description, escaping: .unsafeNone)
                                ),

                                // Details
                                button.class("btn btn-" + variable(\.colorClass) + " btn-rounded").child(
                                    localize(.button)
                                )
                            )
                        )
                    )
            )
        }
    }

    struct RevisitCard: LocalizedTemplate {

        static var localePath: KeyPath<TopicResultContent, String>?

        enum LocalizationKeys: String {
            case repeatDescription = "subjects.repeat.description"
            case start = "subjects.repeat.button"
            case days = "result.repeat.days"
        }

        typealias Context = TopicResultContent

        func build() -> CompiledTemplate {
            return
                div.class("col-md-6 col-lg-4").child(
                    div.class("card d-block").child(
                        div.class("card-body").child(

                            div.class("badge float-right")
                                .if(\.daysUntilRevisit < 3, add: .class("badge-danger"))
                                .if(\.daysUntilRevisit < 11, add: .class("badge-warning"))
                                .if(\.daysUntilRevisit > 10, add: .class("badge-success")).child(
                                    localizeWithContext(.days)
                            ),

                            // Title
                            h3.class("mt-0").child(
                                a.onclick("startPracticeSession(", variable(\.topic.id), ", ", variable(\.subject.id), ");").href("#").class("text-dark").child(
                                    variable(\.topic.name)
                                )
                            ),

                            p.class("text-muted font-13 mb-3").child(
                                localize(.repeatDescription, with: [
                                    "revisitDate" :
                                        b.child(
                                            date(\.revisitDate, dateStyle: .short, timeStyle: .short)
                                    )]
                                )
                            ),

                            a.onclick("startPracticeSession(", variable(\.topic.id), ", ", variable(\.subject.id), ");").href("#").class("text-dark").child(

                                button.type("button").class("btn btn-primary btn-rounded mb-1").child(
                                    i.class("mdi mdi-book-open-variant"),
                                    " " + localize(.start)
                                )
                            )
                        )
                    )
            )
        }
    }
}
