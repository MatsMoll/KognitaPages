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

            public init(errorMessage: String? = nil) {
                self.base = User.Templates.AuthenticateBaseContext(
                    title: "Registrer",
                    description: "Registrer",
                    errorMessage: errorMessage
                )
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
                    FormGroup(label: Strings.registerNameTitle.localized()) {
                        Input()
                            .type(.text)
                            .id("username")
                            .placeholder(localized: Strings.registerNamePlaceholder)
                    }
                    FormGroup(label: Strings.mailTitle.localized()) {
                        Input()
                            .type(.email)
                            .id("email")
                            .placeholder(localized: Strings.mailPlaceholder)
                    }
                    FormGroup(label: Strings.passwordTitle.localized()) {
                        Input()
                            .type(.password)
                            .id("password")
                            .placeholder(localized: Strings.passwordPlaceholder)
                    }
                    FormGroup(label: Strings.registerConfirmPasswordTitle.localized()) {
                        Input()
                            .type(.password)
                            .id("verifyPassword")
                            .placeholder(localized: Strings.registerConfirmPasswordPlaceholder)
                    }

                    Div {
                        Div {
                            Input()
                                .type(.checkbox)
                                .class("custom-control-input")
                                .name("acceptedTermsInput")
                                .id("checkbox-signup")
                            Label {
                                Strings.registerTermsOfServiceTitle.localized()
                                " "
                                Anchor {
                                    Strings.registerTermsOfServiceLink.localized()
                                }
                                .href("#")
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
