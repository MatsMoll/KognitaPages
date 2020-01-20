//
//  CreateSubjectPage.swift
//  App
//
//  Created by Mats Mollestad on 27/02/2019.
//
// swiftlint:disable line_length nesting

import BootstrapKit
import KognitaCore

extension Subject.Templates {
    public struct Create: HTMLTemplate {

        public struct Context {
            let subjectInfo: Subject?
            let user: User

            public init(user: User, subjectInfo: Subject? = nil) {
                self.user = user
                self.subjectInfo = subjectInfo
            }
        }

        public init() {}

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Lag et fag", description: "Lag et fag"))
            ) {
                Row {
                    Div {
                        DismissableError()
                        Div {
                            Div {
                                H4 {
                                    "Lag et nytt fag"
                                }
                                .class("modal-title")
                                .id("create-modal-label")
                            }
                            .class("modal-header")
                            .background(color: .primary)
                            .text(color: .white)

                            Div {
                                Div {
                                    CreateForm(
                                        context: context.subjectInfo
                                    )
                                }
                                .class("p-2")
                            }
                            .class("modal-body")
                        }
                        .class("card")
                    }
                    .class("col-12 pt-5")
                }
            }
            .header {
                Link().href("/assets/css/vendor/summernote-bs4.css").relationship(.stylesheet).type("text/css")
            }
            .scripts {
                Script().source("/assets/js/vendor/summernote-bs4.min.js")
                Script().source("/assets/js/subject/create.js")
            }
        }
    }
}

struct CreateForm: HTMLComponent {

    let context: TemplateValue<Subject?>

    var body: HTML {
        Form {
            FormGroup(label: "Navn") {
                Input()
                    .type(.text)
                    .id("create-subject-name")
                    .placeholder("Mattematikk 1")
                    .value(Unwrap(context) { $0.name })
                    .required()
            }
            .description {
                "Bare lov vanlig bokstaver og mellomrom"
            }

            FormGroup(label: "Beskrivelse") {
                Div {
                    Unwrap(context) { $0.description }
                }
                .id("create-subject-description")
            }

            FormGroup(label: "Kategori") {
                Input()
                    .type(.text)
                    .id("create-subject-category")
                    .placeholder("Teknologi")
                    .value(Unwrap(context) { $0.category })
                    .required()
            }

            Div {
                Label {
                    "Fargekode"
                }
                .for("create-subject-color-class")
                .class("col-form-label")

                ColorCodePicker()
            }
            .class("form-group")

            Button {
                " Lagre"
            }
            .type(.button)
            .on(click: "createSubject()")
            .class("btn-rounded mb-3")
            .button(style: .success)
        }
    }

    struct ColorCodePicker: HTMLComponent {

        var body: HTML {
            Div {
                Subject.ColorClass.allCases.htmlForEach { option in
                    optionHTML(option)
                }
            }
            .class("mt-1")
        }

        func optionHTML(_ option: TemplateValue<Subject.ColorClass>) -> HTML {
            Div {
                Input()
                    .type(.radio)
                    .id(option.rawValue)
                    .class("custom-contol-input mr-2")
                    .name("color-class")
                Label {
                    H4 {
                        Div {
                            option.rawValue
                        }
                        .class("badge badge-" + option.rawValue)
                    }
                }
                .for(option.rawValue)
            }
            .class("custom-control custom-radio")
        }
    }
}
