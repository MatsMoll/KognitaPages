//
//  LoginPage.swift
//  App
//
//  Created by Mats Mollestad on 26/02/2019.
//

import BootstrapKit

public struct LoginPage: HTMLTemplate {

    public struct Context {
        let errorMessage: String?
        let base: BaseTemplateContent

        public init(errorMessage: String? = nil) {
            self.base = BaseTemplateContent(title: "Logg inn", description: "Logg inn")
            self.errorMessage = errorMessage
        }
    }

    public init() {}

    public let context: TemplateValue<Context> = .root()

    public var body: HTML {
        BaseTemplate(context: context.base) {
            KognitaNavigationBar(rootUrl: "")
            Div {
                Div {
                    Div {
                        Div {
                            IF(context.errorMessage.isDefined) {
                                Alert {
                                    Bold(Strings.errorMessage)

                                    context.errorMessage
                                }
                                .isDismissable(true)
                                .background(color: .danger)
                                .text(color: .white)
                            }
                            Div {
                                Div {
                                    Anchor {
                                        Span {
                                            LogoImage()
                                        }
                                    }.href("index.html")
                                }.class("card-header pt-4 pb-4 text-center bg-primary")
                                Div {
                                    Div {
                                        H4(Strings.loginTitle)
                                            .class("text-dark-50 text-center mt-0 font-weight-bold")
                                        P(Strings.loginSubtitle)
                                            .class("text-muted mb-4")
                                    }.class("text-center w-75 m-auto")
                                    Form {
                                        FormGroup(label: Strings.mailTitle.localized()) {
                                            Input()
                                                .type(.email)
                                                .id("email")
                                                .placeholder(localized: Strings.mailPlaceholder)
                                                .required()
                                        }

                                        Div {
                                            Anchor {
                                                Small(Strings.forgottenPassword)
                                            }
                                            .href("/start-reset-password")
                                            .float(.right)
                                            .text(color: .muted)

                                            Label(Strings.passwordTitle)
                                                .for("password")
                                            Input()
                                                .class("form-control")
                                                .type(.password)
                                                .name("password")
                                                .id("password")
                                                .placeholder(localized: Strings.passwordPlaceholder)
                                                .required()
                                        }.class("form-group")
                                        Div {
                                            Button(Strings.loginButton)
                                                .id("submit-button")
                                                .button(style: .primary)
                                                .type(.submit)
                                        }.class("form-group mb-0 text-center")
                                    }
                                    .action("/login")
                                    .method(.post)
                                }
                                .class("card-body p-4")
                            }
                            .class("card")
                            Div {
                                Div {
                                    P(Strings.loginNoUserTitle)
                                        .text(color: .muted)
                                        .display(.inline)
                                    Anchor {
                                        Bold(Strings.loginNoUserLink)
                                    }
                                    .href("/signup")
                                    .class("ml-1")
                                    .text(color: .dark)
                                }
                                .class("col-12 text-center")
                            }.class("row mt-3")
                        }.class("col-lg-5")
                    }.class("row justify-content-center")
                }.class("container")
            }.class("account-pages mt-5 mb-5")
        }
    }
}
