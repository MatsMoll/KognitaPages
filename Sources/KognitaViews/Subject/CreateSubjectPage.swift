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
    public struct Create: TemplateView {

        public struct Context {
            let subjectInfo: Subject?
            let user: User

            public init(user: User, subjectInfo: Subject? = nil) {
                self.user = user
                self.subjectInfo = subjectInfo
            }
        }

        public init() {}

        public let context: RootValue<Context> = .root()

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
        }
    }

    struct CreateForm<T>: HTMLComponent {

        let context: TemplateValue<T, Subject?>

        var body: HTML {
            Form {
                FormGroup(label: "Navn", input: {
                    Input()
                        .type(.text)
                        .id("create-subject-name")
                        .placeholder("Mattematikk 1")
                        .value(context.value(at: \.self?.name))
                        .required()
                }) {
                    Small {
                        "Bare lov vanlig bokstaver og mellomrom"
                    }
                }

                FormGroup(label: "Beskrivelse") {
                    Div {
                        context.value(at: \.self?.description)
                    }
                    .id("create-subject-description")
                }

                FormGroup(label: "Kategori") {
                    Input()
                        .type(.text)
                        .id("create-subject-category")
                        .placeholder("Teknologi")
                        .value(context.value(at: \.self?.category))
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
                    Subject.ColorClass.allCases.forEachHTML { option in
                        optionHTML(option)
                    }
                }
                .class("mt-1")
            }

            func optionHTML(_ option: RootValue<Subject.ColorClass>) -> HTML {
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
                        "Label"
                    }
                    .for(option.rawValue)
                }
                .class("custom-control custom-radio")
            }
        }
    }
}

//public struct CreateSubjectPage: LocalizedTemplate {
//
//    public init() {}
//
//    public static var localePath: KeyPath<CreateSubjectPage.Context, String>? = \.locale
//
//    public enum LocalizationKeys: String {
//        case none
//    }
//
//    public struct Context {
//        let locale = "nb"
//        let base: ContentBaseTemplate.Context
//
//        let subjectInfo: Subject?
//        let colorOptions = Subject.ColorClass.allCases
//
//        public init(user: User, subjectInfo: Subject? = nil) {
//            self.base = .init(user: user, title: "Lag et fag")
//            self.subjectInfo = subjectInfo
//        }
//    }
//
//    public func build() -> CompiledTemplate {
//
//        return embed(
//            ContentBaseTemplate(
//                body:
//
//                div.class("row").child(
//                    div.class("col-12 pt-5").child(
//
//                        DismissableError(),
//
//                        div.class("card").child(
//                            div.class("modal-header bg-primary text-white").child(
//                                h4.class("modal-title").id("create-modal-label").child(
//                                    "Lag et nytt fag"
//                                )
//                            ),
//                            div.class("modal-body").child(
//                                div.class("p-2").child(
//
//                                    form.novalidate.child(
//                                        div.class("form-group").child(
//                                            label.for("create-subject-name").class("col-form-label").child(
//                                                "Navn"
//                                            ),
//                                            input.type("text").class("form-control").id("create-subject-name").placeholder("R2 Matte").required.value(variable(\.subjectInfo?.name)),
//                                            small.child(
//                                                "Bare lov vanlig bokstaver og mellomrom"
//                                            )
//                                        ),
//                                        div.class("form-group").child(
//                                            label.for("create-subject-description").class("col-form-label").child(
//                                                "Beskrivelse"
//                                            ),
//                                            div.id("create-subject-description").child(
//                                                variable(\.subjectInfo?.description)
//                                            )
//                                        ),
//                                        div.class("form-group").child(
//                                            label.for("create-subject-category").class("col-form-label").child(
//                                                "Kategori"
//                                            ),
//                                            input.type("text").class("form-control").id("create-subject-category").placeholder("Teknologi").value(variable(\.subjectInfo?.category)).required
//                                        ),
//                                        div.class("form-group").child(
//                                            label.for("create-subject-color-class").class("col-form-label").child(
//                                                "Fargekode"
//                                            ),
//                                            div.class("mt-1").child(
//                                                forEach(
//                                                    in:     \.colorOptions,
//                                                    render: ColorClassOption()
//                                                )
//                                            )
//                                        ),
//                                        button.type("button").onclick("createSubject()").class("btn btn-success btn-rounded mb-3").child(
//                                            " Lagre"
//                                        )
//                                    )
//                                )
//                            )
//                        )
//                    )
//                ),
//
//                headerLinks:
//                link.href("/assets/css/vendor/summernote-bs4.css").rel("stylesheet").type("text/css"),
//
//                scripts: [
//                    script.src("/assets/js/vendor/summernote-bs4.min.js"),
//                    script.src("/assets/js/subject/create.js")
//                ]
//            ),
//            withPath: \.base)
//    }
//
//
//    struct ColorClassOption: ContextualTemplate {
//
//        typealias Context = Subject.ColorClass
//
//        func build() -> CompiledTemplate {
//            return div.class("custom-control custom-radio").child(
//                input.type("radio").id(variable(\.rawValue)).class("custom-contol-input mr-2").name("color-class"),
//                label.for(variable(\.rawValue)).child(
//                    h4.child(
//                        div.class("badge badge-" + variable(\.rawValue)).child(
//                            variable(\.rawValue)
//                        )
//                    )
//                )
//            )
//        }
//    }
//}
