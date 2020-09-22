//
//  ResetPasswordPage.swift
//  KognitaViews
//
//  Created by Mats Mollestad on 9/4/19.
//

import BootstrapKit

extension User.Templates.ResetPassword {

    public struct Reset: HTMLTemplate {

        public struct Context {
            let token: String

            public init(token: String, alertMessage: (message: String, colorClass: String)? = nil) {
                self.token = token
            }
        }

        public var body: HTML {
            User.Templates.AuthenticateBase(
                context: TemplateValue<User.Templates.AuthenticateBaseContext>.constant(
                    .init(
                        title: "Gjenopprett passord",
                        description: "Gjenopprett passord"
                    )
            )) {

                Div {
                    Text(Strings.resetPasswordTitle)
                        .class("text-dark-50")
                        .text(alignment: .center)
                        .margin(.zero, for: .top)
                        .font(style: .bold)
                        .style(.heading4)

                    Text(Strings.resetPasswordSubtitle)
                        .text(color: .muted)
                        .margin(.four, for: .bottom)
                        .style(.paragraph)
                }
                .margin(.auto)
                .width(portion: .threeQuarter)
                .text(alignment: .center)

                Form {
                    Input()
                        .type(.hidden)
                        .name("token")
                        .value(context.token)

                    FormGroup(label: Strings.passwordTitle.localized()) {
                        Input()
                            .type(.password)
                            .id("password")
                            .placeholder(localized: Strings.passwordPlaceholder)
                            .minLength(6)
                            .required()
                    }
                    FormGroup(label: Strings.registerConfirmPasswordTitle.localized()) {
                        Input()
                            .type(.password)
                            .id("verifyPassword")
                            .placeholder(localized: Strings.registerConfirmPasswordPlaceholder)
                            .minLength(6)
                            .required()
                    }

                    Div {
                        Button {
                            "Endre passord"
                        }
                        .type(.submit)
                        .button(style: .primary)
                    }
                    .text(alignment: .center)
                }
                .action("/reset-password")
                .method(.post)
            }
        }
    }
}
