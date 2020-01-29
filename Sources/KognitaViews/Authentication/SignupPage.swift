//
//  SignupPage.swift
//  App
//
//  Created by Mats Mollestad on 26/02/2019.
//
// swiftlint:disable line_length nesting

import BootstrapKit
import KognitaCore

extension User.Templates {
    public struct Signup: HTMLTemplate {

        public struct Context {
            let base: User.Templates.AuthenticateBaseContext
            let submittedForm: User.Create.Data?

            public init(errorMessage: String? = nil, submittedForm: User.Create.Data? = nil) {
                self.base = User.Templates.AuthenticateBaseContext(
                    title: "Registrer",
                    description: "Registrer",
                    errorMessage: errorMessage
                )
                self.submittedForm = submittedForm
            }
        }

        public init() {}

        public var body: HTML {
            User.Templates.AuthenticateBase(
                context: context.base
            ) {
                Div {
                    Text {
                        Strings.registerTitle.localized()
                    }
                    .class("text-dark-50")
                    .text(alignment: .center)
                    .margin(.zero, for: .top)
                    .font(style: .bold)
                    .style(.heading4)

                    Text {
                        Strings.registerSubtilte.localized()
                    }
                    .text(color: .muted)
                    .margin(.four, for: .bottom)
                }
                .class("w-75 m-auto")
                .text(alignment: .center)

                Form {
                    FormGroup(label: Strings.registerUsernameTitle.localized()) {
                        Input()
                            .type(.text)
                            .id("username")
                            .placeholder(localized: Strings.registerUsernamePlaceholder)
                            .minLength(3)
                            .maxLength(20)
                            .pattern(regex: "[A-Za-z0-9]+")
                            .required()
                            .value(Unwrap(context.submittedForm) { $0.username })
                    }
                    .invalidFeedback {
                        "Brukernavnet må være lengre enn tre bokstaver og bare inneholde bokstaver og tall."
                    }

                    FormGroup(label: Strings.mailTitle.localized()) {
                        Input()
                            .type(.email)
                            .id("email")
                            .placeholder("kognita@stud.ntnu.no")
                            .pattern(regex: ".*@.*ntnu.no")
                            .required()
                            .value(Unwrap(context.submittedForm) { $0.email })
                    }
                    .description {
                        "Må være en NTNU mail"
                    }

                    FormGroup(label: Strings.passwordTitle.localized()) {
                        Input()
                            .type(.password)
                            .id("password")
                            .placeholder(localized: Strings.passwordPlaceholder)
                            .minLength(6)
                            .required()
                    }
                    .invalidFeedback {
                        "Passordet må være lengre enn 6 tegn"
                    }

                    FormGroup(label: Strings.registerConfirmPasswordTitle.localized()) {
                        Input()
                            .type(.password)
                            .id("verifyPassword")
                            .placeholder(localized: Strings.registerConfirmPasswordPlaceholder)
                            .minLength(6)
                            .required()
                    }
                    .invalidFeedback {
                        "Må være det samme som passordet ovenfor"
                    }

                    Div {
                        Div {
                            Input()
                                .type(.checkbox)
                                .class("custom-control-input")
                                .name("acceptedTermsInput")
                                .id("checkbox-signup")
                                .required()
                            Label {
                                Strings.registerTermsOfServiceTitle.localized()
                                " "
                                Anchor {
                                    Strings.registerTermsOfServiceLink.localized()
                                }
                                .href("/terms-of-service")
                                .class("text-dark")
                            }
                            .class("custom-control-label")
                            .for("checkbox-signup")
                        }
                        .class("custom-control custom-checkbox")
                    }
                    .class("form-group")

                    Div {
                        Button {
                            Strings.registerButton.localized()
                        }
                        .button(style: .primary)
                        .type(.submit)
                    }
                    .class("form-group")
                    .text(alignment: .center)
                    .margin(.zero, for: .bottom)
                }
                .action("/signup")
                .method(.post)
                .modify(if: context.submittedForm.isDefined) {
                    $0.class("was-validated")
                }

                Script(source: "/assets/js/form-feedback.js")
            }
            .otherActions {
                Row {
                    Div {
                        Text {
                            Anchor {
                                Bold { Strings.alreadyHaveUser.localized() }
                            }
                            .href("/login")
                            .text(color: .dark)
                            .margin(.one, for: .left)
                        }
                        .text(color: .muted)
                        .style(.paragraph)
                    }
                    .text(alignment: .center)
                    .column(width: .twelve)
                }
                .margin(.three, for: .top)
            }
        }
    }
}
