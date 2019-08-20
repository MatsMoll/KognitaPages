//
//  SelectSubjectTemplate.swift
//  App
//
//  Created by Mats Mollestad on 20/08/2019.
//
// swiftlint:disable line_length nesting

import Foundation
import HTMLKit
import KognitaCore

public class SelectSubjectTemplate: LocalizedTemplate {

    public init() {}

    // Static so it can be referanceed in the base template
    static let title = "Tema liste"

    public static var localePath: KeyPath<SelectSubjectTemplate.Context, String>? = \.locale

    public enum LocalizationKeys: String {
        case repeatTitle = "subjects.repeat.title"

        case title = "subjects.title"
        case listTitle = "subjects.list.title"
        case noContent = "subjects.no.content"

    }

    public struct Context {
        let locale = "nb"
        let base: ContentBaseTemplate.Context
        let cards: [Card.Context]

        public init(user: User, subjects: [Subject], redirectPathStart: String, redirectPathEnd: String) {
            self.base = .init(user: user, title: SubjectListTemplate.title)
            self.cards = subjects.map { .init(subject: $0, startPath: redirectPathStart, endPath: redirectPathEnd) }
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

                h3.child(
                    "Velg tema"
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
                )
            ),
            withPath: \.base)
    }

    // MARK: - Subview

    struct Card: LocalizedTemplate {
        static var localePath: KeyPath<SelectSubjectTemplate.Card.Context, String>?

        enum LocalizationKeys: String {
            case button = "subjects.subject.card.button"
        }

        struct Context {
            let subject: Subject
            let startPath: String
            let endPath: String
        }

        func build() -> CompiledTemplate {
            return
                div.class("col-md-6 col-xl-6").child(
                    a.href(variable(\.startPath) + variable(\.subject.id) + variable(\.endPath)).class("text-dark").child(
                        div.class("card d-block").child(

                            // Thumbnail
                            div.class("card-header text-white bg-" + variable(\.subject.colorClass.rawValue)).child(
                                h3.child(
                                    variable(\.subject.name)
                                ),
                                small.class("badge badge-light").child(
                                    variable(\.subject.category)
                                )
                            ),
                            div.class("card-body position-relative").child(

                                p.child(
                                    variable(\.subject.description, escaping: .unsafeNone)
                                ),

                                // Details
                                button.class("btn btn-" + variable(\.subject.colorClass.rawValue) + " btn-rounded").child(
                                    "Lag tema"
                                )
                            )
                        )
                    )
            )
        }
    }
}

