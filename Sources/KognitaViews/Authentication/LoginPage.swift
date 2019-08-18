//
//  LoginPage.swift
//  App
//
//  Created by Mats Mollestad on 26/02/2019.
//
// swiftlint:disable line_length nesting

import HTMLKit


public class LoginPage: LocalizedTemplate {

    public init() {}

    public static var localePath: KeyPath<LoginPage.Context, String>? = \.locale

    public enum LocalizationKeys: String {

        case errorMessage = "error.message"
        case menuRegister = "menu.register"

        case title = "login.title"
        case subtitle = "login.subtitle"

        case mailTitle = "login.mail.title"
        case mailPlaceholder = "login.mail.placeholder"

        case passwordTitle = "login.password.title"
        case passwordPlaceholder = "login.password.placeholder"

        case forgottenPassword = "login.forgotpw.link"

        case loginButton = "login.button"

        case noUserTitle = "login.no.user.title"
        case noUserLink = "login.no.user.link"
    }

    public struct Context {
        let locale = "nb"
        let base: BaseTemplate.Context
        let errorMessage: String?

        public init(errorMessage: String? = nil) {
            self.base = .init(title: "Logg inn", description: "Logg inn")
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

                                // Login card
                                div.class("card").child(

                                    // Logo
                                    div.class("card-header pt-4 pb-4 text-center bg-primary").child(
                                        a.href("index.html").child(
                                            span.child(
                                                img.src("assets/images/logo.png").alt("").height(30)
                                            )
                                        )
                                    ),
                                    div.class("card-body p-4").child(

                                        // Description
                                        div.class("text-center w-75 m-auto").child(
                                            h4.class("text-dark-50 text-center mt-0 font-weight-bold").child(
                                                localize(.title)
                                            ),
                                            p.class("text-muted mb-4").child(
                                                localize(.subtitle)
                                            )
                                        ),

                                        // Form
                                        form.action("/login").method(.post).child(

                                            // Email
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

                                            // Password
                                            div.class("form-group").child(
                                                a.href("#").class("text-muted float-right").child(
                                                    small.child(
                                                        localize(.forgottenPassword)
                                                    )
                                                ),
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

                                            // Remember me
//                                            div.class("form-group mb-3").child(
//                                                div.class("custom-control custom-checkbox").child(
//                                                    input.type("checkbox").class("custom-control-input").id("checkbox-signin").checked,
//                                                    label.class("custom-control-label").for("checkbox-signin").child(
//                                                        "Remember me"
//                                                    )
//                                                )
//                                            ),

                                            // Login button
                                            div.class("form-group mb-0 text-center").child(
                                                button.id("submit-button").class("btn btn-primary").type("submit").child(
                                                    localize(.loginButton)
                                                )
                                            )
                                        )
                                    )
                                ),

                                // Actions
                                div.class("row mt-3").child(
                                    div.class("col-12 text-center").child(
                                        p.class("text-muted").child(

                                            localize(.noUserTitle) + " ",

                                            // Sign up
                                            a.href("/signup").class("text-dark ml-1").child(
                                                b.child(
                                                    localize(.noUserLink)
                                                )
                                            )
                                        )
                                    )
                                )
                            )
                        )
                    )
                )
            ),
            withPath: \.base)
    }
}
