//
//  LoginPage.swift
//  App
//
//  Created by Mats Mollestad on 26/02/2019.
//

import BootstrapKit

struct FeideLoginButton: HTMLComponent, AttributeNode {
    
    var attributes: [HTMLAttribute] = []
    
    func copy(with attributes: [HTMLAttribute]) -> FeideLoginButton {
        FeideLoginButton.init(attributes: attributes)
    }
    
    var body: HTML {
        Anchor {
            Img()
                .source("https://www.feide.no/sites/feide.no/files/upload/symbol_digital_symbol-blaa_feide.png")
                .margin(.one, for: .right)
                .style(css: "height: 19px")
            
            "Logg inn med Feide"
        }
        .button(style: .light)
        .href(Paths.loginWithFeide)
        .add(attributes: attributes)
    }
}

public struct LoginPage: HTMLTemplate {

    public struct Context {
        let errorMessage: String?
        let base: BaseTemplateContent

        public init(showCookieMessage: Bool, errorMessage: String? = nil) {
            self.base = BaseTemplateContent(title: "Logg inn", description: "Logg inn", showCookieMessage: showCookieMessage)
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
                                    }.href(Paths.landingPage)
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
                                                .autofocus()
                                        }

                                        Div {
                                            Anchor {
                                                Small(Strings.forgottenPassword)
                                            }
                                            .href(Paths.startResetPassword)
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
                                            
                                            FeideLoginButton()
                                                .margin(.one, for: .left)
                                        }.class("form-group mb-0 text-center")
                                    }
                                    .action(Paths.login)
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
                                    .href(Paths.signup)
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
