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
            
            var baseContent: BaseTemplateContent {
                .init(
                    title: title,
                    description: title
                )
            }
            
            var title: String {
                if subjectInfo != nil {
                    return "Rediger faget"
                } else {
                    return "Lag et nytt fag"
                }
            }
        }

        public init() {}

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: context.baseContent
//                .constant(.init(title: "Lag et fag", description: "Lag et fag"))
            ) {
                Row {
                    Div {
                        DismissableError()
                        Div {
                            Div {
                                H4 {
                                    context.baseContent.title
//                                    "Lag et nytt fag"
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
                                    ActionButtons(
                                        subject: context.subjectInfo
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
                Stylesheet(url: "/assets/css/vendor/simplemde.min.css")
            }
            .scripts {
                Script().source("/assets/js/vendor/simplemde.min.js")
                Script(source: "/assets/js/markdown-renderer.js")
                Script(source: "/assets/js/markdown-editor.js")
                IF(context.subjectInfo.isDefined) {
                    Script().source("/assets/js/subject/edit.js")
//                    Script().source("/assets/js/subject/delete.js") // Might add later
                }.else {
                    Script().source("/assets/js/subject/create.js")
                }
            }
        }
        
        struct ActionButtons: HTMLComponent {

            @TemplateValue(Subject?.self)
            var subject

            var body: HTML {
                Unwrap(subject) { subject in
                    Button {
                        " Lagre endringer"
                    }
                    .type(.button)
                    .on(click: "editSubject(" + subject.id + ")")
                    .button(style: .success)
                    .isRounded()
                    .margin(.two, for: .right)

                    Button {
                        " Slett"
                    }
                    .type(.button)
                    .on(click: "deleteSubject(" + subject.id + ")")
                    .button(style: .danger)
                    .isRounded()
                }.else {
                    Button {
                        " Lagre"
                    }
                    .type(.button)
                    .on(click: "createSubject()")
                    .button(style: .success)
                    .isRounded()
                }
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
                    .placeholder("Matematikk 1")
                    .value(Unwrap(context) { $0.name })
                    .required()
            }
            .description {
                "Bruk kun vanlige bokstaver, tall og mellomrom"
            }

            FormGroup(label: "Beskrivelse") {
                TextArea {
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
