//
//  SignupPage.swift
//  App
//
//  Created by Mats Mollestad on 26/02/2019.
//
// swiftlint:disable line_length nesting

import HTMLKit


public struct SignupPage: LocalizedTemplate {

    public init() {}

    public static var localePath: KeyPath<SignupPage.Context, String>? = \.locale

    public enum LocalizationKeys: String {

        case title = "register.title"
        case subtitle = "register.subtitle"

        case nameTitle = "register.name.title"
        case namePlaceholder = "register.name.placeholder"

        case mailTitle = "register.mail.title"
        case mailPlaceholder = "register.mail.placeholder"

        case passwordTitle = "register.password.title"
        case passwordPlaceholder = "register.password.placeholder"

        case confirmPasswordTitle = "register.password.confirmation.title"
        case confirmPasswordPlaceholder = "register.password.confirmation.placeholder"

        case termsOfServiceTitle = "register.tos.description"
        case termsOfServiceLink = "register.tos.link"

        case registerButton = "register.button"

        case haveUser = "register.already.user.description"

        case loginMenu = "menu.login"

        case errorMessage = "error.message"
    }


    public struct Context {
        let locale = "nb"
        let base: BaseTemplate.Context
        let errorMessage: String?

        public init(errorMessage: String? = nil) {
            self.base = .init(title: "Registrer", description: "Registrer")
            self.errorMessage = errorMessage
        }
    }

    public func build() -> CompiledTemplate {
        return embed(
            BaseTemplate(
                body:

                NavigationBar(),
                div.class("account-pages mt-5 mb-5").child(

                    div.class("container").child(
                        div.class("row justify-content-center").child(
                            div.class("col-lg-5").child(
                                
                                // Error Message
                                renderIf(
                                    isNotNil: \.errorMessage,


                                    div.class("alert alert-secondary alert-dismissible bg-danger text-white border-0 fade show").role("alert").child(
                                        button.type("button").class("close").dataDismiss("alert").ariaLabel("Close").child(
                                            span.ariaHidden("true").child(
                                                "×"
                                            )
                                        ),
                                        strong.child(
                                            localize(.errorMessage)
                                        ),
                                        variable(\.errorMessage)
                                    )
                                ),

                                // Form
                                div.class("card").child(
                                    comment(" Logo"),
                                    div.class("card-header pt-4 pb-4 text-center bg-primary").child(
                                        a.href("index.html").child(
                                            span.child(
                                                img.src("assets/images/logo.png").alt("").height(18)
                                            )
                                        )
                                    ),
                                    div.class("card-body p-4").child(
                                        div.class("text-center w-75 m-auto").child(
                                            h4.class("text-dark-50 text-center mt-0 font-weight-bold").child(
                                                localize(.title)
                                            ),
                                            p.class("text-muted mb-4").child(
                                                localize(.subtitle)
                                            )
                                        ),
                                        form.action("/signup").method(.post).child(
                                            div.class("form-group").child(
                                                label.for("name").child(
                                                    localize(.nameTitle)
                                                ),
                                                input.class("form-control")
                                                    .type("text")
                                                    .name("name")
                                                    .id("name")
                                                    .placeholder(localize(.namePlaceholder))
                                                    .required
                                            ),
                                            div.class("form-group").child(
                                                label.for("emailaddress").child(
                                                    localize(.mailTitle)
                                                ),
                                                input.class("form-control")
                                                    .type("email")
                                                    .name("email")
                                                    .id("email")
                                                    .placeholder(localize(.mailPlaceholder))
                                                    .required
                                            ),
                                            div.class("form-group").child(
                                                label.for("password").child(
                                                    localize(.passwordTitle)
                                                ),
                                                input.class("form-control")
                                                    .type("password")
                                                    .name("password")
                                                    .id("password")
                                                    .placeholder(localize(.passwordPlaceholder))
                                                    .required
                                            ),
                                            div.class("form-group").child(
                                                label.for("verifyPassword").child(
                                                    localize(.confirmPasswordTitle)
                                                ),
                                                input.class("form-control")
                                                    .type("password")
                                                    .name("verifyPassword")
                                                    .id("verifyPassword")
                                                    .placeholder(localize(.confirmPasswordPlaceholder))
                                                    .required
                                            ),
                                            div.class("form-group").child(
                                                div.class("custom-control custom-checkbox").child(

                                                    input.type("checkbox")
                                                        .class("custom-control-input")
                                                        .name("acceptedTermsInput")
                                                        .id("checkbox-signup")
                                                        .required,

                                                    label.class("custom-control-label").for("checkbox-signup").child(
                                                        localize(.termsOfServiceTitle) + " ",
                                                        a.href("#").class("text-dark").child(
                                                            localize(.termsOfServiceLink)
                                                        )
                                                    )
                                                )
                                            ),
                                            div.class("form-group mb-0 text-center").child(
                                                button.class("btn btn-primary").type("submit").child(
                                                    localize(.registerButton)
                                                )
                                            )
                                        )
                                    )
                                ),

                                div.class("row mt-3").child(
                                    div.class("col-12 text-center").child(
                                        p.class("text-muted").child(
                                            localize(.haveUser) + " ",

                                            a.href("/login").class("text-dark ml-1").child(
                                                b.child(
                                                    localize(.loginMenu)
                                                )
                                            )
                                        )
                                    )
                                )
                            )
                        )
                    )
                ),

                script.src("/assets/js/app.min.js").type("text/javascript")
            ),
            withPath: \.base)
    }
}
