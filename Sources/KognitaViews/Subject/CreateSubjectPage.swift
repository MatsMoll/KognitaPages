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
        let colorOptions = Subject.ColorClass.allCases

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
                    div.class("col-12 pt-5").child(

                        DismissableError(),

                        div.class("card").child(
                            div.class("modal-header bg-primary text-white").child(
                                h4.class("modal-title").id("create-modal-label").child(
                                    "Lag et nytt fag"
                                )
                            ),
                            div.class("modal-body").child(
                                div.class("p-2").child(

                                    form.novalidate.child(
                                        div.class("form-group").child(
                                            label.for("create-subject-name").class("col-form-label").child(
                                                "Navn"
                                            ),
                                            input.type("text").class("form-control").id("create-subject-name").placeholder("R2 Matte").required.value(variable(\.subjectInfo?.name)),
                                            small.child(
                                                "Bare lov vanlig bokstaver og mellomrom"
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
                                            label.for("create-subject-category").class("col-form-label").child(
                                                "Kategori"
                                            ),
                                            input.type("text").class("form-control").id("create-subject-category").placeholder("Teknologi").value(variable(\.subjectInfo?.category)).required
                                        ),
                                        div.class("form-group").child(
                                            label.for("create-subject-color-class").class("col-form-label").child(
                                                "Fargekode"
                                            ),
                                            div.class("mt-1").child(
                                                forEach(
                                                    in:     \.colorOptions,
                                                    render: ColorClassOption()
                                                )
                                            ) 
                                        ),
                                        button.type("button").onclick("createSubject()").class("btn btn-success btn-rounded mb-3").child(
                                            " Lagre"
                                        )
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


    struct ColorClassOption: ContextualTemplate {

        typealias Context = Subject.ColorClass

        func build() -> CompiledTemplate {
            return div.class("custom-control custom-radio").child(
                input.type("radio").id(variable(\.rawValue)).class("custom-contol-input mr-2").name("color-class"),
                label.for(variable(\.rawValue)).child(
                    h4.child(
                        div.class("badge badge-" + variable(\.rawValue)).child(
                            variable(\.rawValue)
                        )
                    )
                )
            )
        }
    }
}
