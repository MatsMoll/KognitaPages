//
//  CreateSubjectPage.swift
//  App
//
//  Created by Mats Mollestad on 27/02/2019.
//
// swiftlint:disable line_length nesting

import BootstrapKit

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
                    description: title,
                    showCookieMessage: false
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
            ) {
                
                PageTitle(title: context.title)
                
                Row {
                    Div {
                        Card {
                            Div {
                                CreateForm(
                                    context: context.subjectInfo
                                )
                                DismissableError()
                                ActionButtons(
                                    subject: context.subjectInfo
                                )
                            }
                            .padding(.two)
                        }
                        .header {
                            Text { context.baseContent.title }
                                .style(.heading4)
                                .class("modal-title")
                                .id("create-modal-label")
                        }
                        .modifyHeader {
                            $0.background(color: .primary)
                                .text(color: .white)
                        }
                    }
                    .column(width: .twelve)
                }
            }
            .header {
                Stylesheet(url: "/assets/css/vendor/simplemde.min.css")
            }
            .scripts {
                Script().source("/assets/js/vendor/simplemde.min.js")
                Script(source: "/assets/js/markdown-renderer.js")
                Script(source: "/assets/js/markdown-editor.js")
                Script(source: "/assets/js/subject/json-data.js")
                IF(context.subjectInfo.isDefined) {
                    Script().source("/assets/js/subject/edit.js")
                    Script().source("/assets/js/subject/delete.js")
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
                    .id("subject-name")
                    .placeholder("Matematikk 1")
                    .value(Unwrap(context) { $0.name })
                    .required()
            }
            .description {
                "Bruk kun vanlige bokstaver, tall og mellomrom"
            }

            FormGroup(label: "Beskrivelse") {
                MarkdownEditor(id: "subject-description") {
                    Unwrap(context) { $0.description }
                }
            }
            
            Row {
                FormGroup(label: "Emnekode") {
                    Input()
                        .type(.text)
                        .id("subject-code")
                        .placeholder("TDT4120")
                        .value(Unwrap(context) { $0.code })
                        .required()
                }
                .column(width: .six, for: .medium)

                FormGroup(label: "Kategori") {
                    Input()
                        .type(.text)
                        .id("subject-category")
                        .placeholder("Teknologi")
                        .value(Unwrap(context) { $0.category })
                        .required()
                }
                .column(width: .six, for: .medium)
            }
        }
    }
}
