//
//  LoginPage.swift
//  App
//
//  Created by Mats Mollestad on 26/02/2019.
//
// swiftlint:disable line_length nesting

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
                                Div {
                                    Button {
                                        Span {
                                            "×"
                                        }.aria(for: "hidden", value: "true")
                                    }
                                    .type(.button)
                                    .class("close")
                                    .data(for: "dismiss", value: "alert")
                                    .aria(for: "label", value: "Close")

                                    Bold(Strings.errorMessage)

                                    context.errorMessage
                                }
                                .class("alert alert-secondary alert-dismissible bg-danger text-white border-0 fade show")
                                .role("alert")
                            }
                            Div {
                                Div {
                                    Anchor {
                                        Span {
                                            Img().source("assets/images/logo.png").alt("Logo").height(30)
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
                                        Div {
                                            Label(Strings.mailTitle)
                                                .for("emailaddress")
                                            Input()
                                                .class("form-control")
                                                .type(.email)
                                                .name("email")
                                                .id("email")
                                                .placeholder(localized: Strings.mailPlaceholder)
                                        }.class("form-group")
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
                                        }.class("form-group")
                                        Div {
                                            Button(Strings.loginButton)
                                                .id("submit-button")
                                                .class("btn btn-primary")
                                                .type(.submit)
                                        }.class("form-group mb-0 text-center")
                                    }.action("/login").method(.post)
                                }.class("card-body p-4")
                            }.class("card")
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
