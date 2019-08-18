//
//  CreateSubjectPage.swift
//  App
//
//  Created by Mats Mollestad on 27/02/2019.
//
// swiftlint:disable line_length nesting

import HTMLKit
import KognitaCore


public struct CreateSubjectPage: LocalizedTemplate {

    public init() {}

    public static var localePath: KeyPath<CreateSubjectPage.Context, String>? = \.locale

    public enum LocalizationKeys: String {
        case none
    }

    public struct Context {
        let locale = "nb"
        let base: ContentBaseTemplate.Context

        let subjectInfo: Subject?

        public init(user: User, subjectInfo: Subject? = nil) {
            self.base = .init(user: user, title: "Lag et fag")
            self.subjectInfo = subjectInfo
        }
    }

    public func build() -> CompiledTemplate {

        return embed(
            ContentBaseTemplate(
                body:

                div.class("row").child(
                    div.class("col-12").child(
                        div.class("modal-header").child(
                            h4.class("modal-title").id("create-modal-label").child(
                                "Lag et nytt fag"
                            )
                        ),
                        div.class("modal-body").child(
                            div.class("p-2").child(
                                form.novalidate.child(
                                    div.class("form-row").child(
                                        div.class("form-group col-md-6").child(
                                            label.for("create-subject-name").class("col-form-label").child(
                                                "Navn"
                                            ),
                                            input.type("text").class("form-control").id("create-subject-name").placeholder("R2 Matte").required.value(variable(\.subjectInfo?.name)),
                                            small.child(
                                                "Bare lov vanlig bokstaver og mellomrom"
                                            )
                                        ),
                                        div.class("form-group col-md-6").child(
                                            label.for("create-subject-code").class("col-form-label").child(
                                                "Fagkode"
                                            ),
                                            input.type("text").class("form-control").id("create-subject-code").placeholder("REA2013").required.value(variable(\.subjectInfo?.code)),
                                            small.child(
                                                "Skriv på formatet: 3-5 Store bokstaver + 4-6 tall"
                                            )
                                        )
                                    ),
                                    div.class("form-group").child(
                                        label.for("create-subject-description").class("col-form-label").child(
                                            "Beskrivelse"
                                        ),
                                        div.id("create-subject-description").child(
                                            variable(\.subjectInfo?.description)
                                        )
                                    ),
                                    div.class("form-group").child(
                                        label.for("create-subject-image").class("col-form-label").child(
                                            "Bilde URL"
                                        ),
                                        input.type("url").class("form-control").id("create-subject-image").placeholder("https://et-eksempel.no/url.png").required.value(variable(\.subjectInfo?.imageURL)),
                                        small.child(
                                            "Støtter png og jpg format"
                                        )
                                    ),
                                    button.type("button").onclick("createSubject()").class("btn btn-success btn-rounded mb-3").child(
                                        " Lagre"
                                    )
                                )
                            )
                        )
                    )
                ),

                headerLinks:
                link.href("/assets/css/vendor/summernote-bs4.css").rel("stylesheet").type("text/css"),

                scripts: [
                    script.src("/assets/js/vendor/summernote-bs4.min.js"),
                    script.src("/assets/js/subject/create.js")
                ]
            ),
            withPath: \.base)
    }
}
