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
                context: context.base,
                cardBody:
                Div {
                    Text {
                        "localize(.title)"
                    }
                    .class("text-dark-50")
                    .text(alignment: .center)
                    .margin(.zero, for: .top)
                    .font(style: .bold)
                    .style(.heading4)

                    Text {
                        "localize(.subtitle)"
                    }
                    .text(color: .muted)
                    .margin(.four, for: .bottom)
                }
                .class("w-75 m-auto")
                .text(alignment: .center) +

                Form {
                    FormGroup(label: "localize(.nameTitle)") {
                        Input()
                            .type(.text)
                            .id("name")
                            .placeholder("localize(.namePlaceholder)")
                    }
                    FormGroup(label: "localize(.mailTitle)") {
                        Input()
                            .type(.email)
                            .id("email")
                            .placeholder("localize(.mailPlaceholder)")
                    }
                    FormGroup(label: "localize(.passwordTitle)") {
                        Input()
                            .type(.password)
                            .id("password")
                            .placeholder("localize(.passwordPlaceholder)")
                    }
                    FormGroup(label: "localize(.confirmPasswordTitle)") {
                        Input()
                            .type(.password)
                            .id("verifyPassword")
                            .placeholder("localize(.confirmPasswordPlaceholder)")
                    }

                    Div {
                        Div {
                            Input()
                                .type(.checkbox)
                                .class("custom-control-input")
                                .name("acceptedTermsInput")
                                .id("checkbox-signup")
                            Label {
                                "localize(.termsOfServiceTitle) "
                                Anchor {
                                    "localize(.termsOfServiceLink)"
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
                            "localize(.registerButton)"
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
            )
        }
    }
}
