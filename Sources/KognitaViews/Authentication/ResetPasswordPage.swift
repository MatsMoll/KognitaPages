//
//  ResetPasswordPage.swift
//  KognitaViews
//
//  Created by Mats Mollestad on 9/4/19.
//

import HTMLKit
import KognitaCore

struct AuthenticationBaseTemplate : ContextualTemplate {

    struct Context {
        let base: BaseTemplate.Context
        let message: String?
        let colorClass: String?
    }

    let cardBody: CompiledTemplate
    let otherActions: CompiledTemplate
    let rootUrl: String

    init(cardBody: CompiledTemplate, otherActions: CompiledTemplate, rootUrl: String = "") {
        self.cardBody = cardBody
        self.otherActions = otherActions
        self.rootUrl = rootUrl
    }

    func build() -> CompiledTemplate {

        return embed(
            BaseTemplate(
                body:

                NavigationBar(rootUrl: rootUrl),
                div.class("account-pages mt-5 mb-5").child(
                    div.class("container").child(
                        div.class("row justify-content-center").child(
                            div.class("col-lg-5").child(

                                // Error Message
                                renderIf(
                                    isNotNil: \.message,

                                    div.class("alert alert-secondary alert-dismissible bg-" + variable(\.colorClass) + " text-white border-0 fade show").role("alert").child(
                                        button.type("button").class("close").dataDismiss("alert").ariaLabel("Close").child(
                                            span.ariaHidden("true").child(
                                                "×"
                                            )
                                        ),
                                        strong.child(
                                            ""
                                        ),
                                        variable(\.message)
                                    )
                                ),


                                // Card
                                div.class("card").child(

                                    // Logo
                                    div.class("card-header pt-4 pb-4 text-center bg-primary").child(
                                        a.href("index.html").child(
                                            span.child(
                                                img.src(rootUrl + "/assets/images/logo.png").alt("").height(30)
                                            )
                                        )
                                    ),
                                    div.class("card-body p-4").child(
                                        cardBody
                                    )
                                ),

                                otherActions
                            )
                        )
                    )
                )
            ),
            withPath: \.base
        )
    }
}

extension User.ResetPassword {
    public struct Templates {}
}

extension User.ResetPassword.Templates {
    
    public class Start: LocalizedTemplate {

        public static var localePath: KeyPath<Start.Context, String>? = \.locale

        public enum LocalizationKeys: String {

            case errorMessage = "error.message"
            case menuRegister = "menu.register"

            case title = "login.title"
            case subtitle = "login.subtitle"

            case mailTitle = "login.mail.title"
            case mailPlaceholder = "login.mail.placeholder"

            case noUserTitle = "login.no.user.title"
            case noUserLink = "login.no.user.link"
        }

        public struct Context {
            let locale = "nb"
            let base: AuthenticationBaseTemplate.Context

            public init(alertMessage: (message: String, colorClass: String)? = nil) {
                self.base = .init(
                    base: .init(
                        title: "Gjenopprett Passord",
                        description: "Gjenopprett passord"),
                    message: alertMessage?.message,
                    colorClass: alertMessage?.colorClass
                )
            }
        }

        public init() {}

        public func build() -> CompiledTemplate {

            return embed(
                AuthenticationBaseTemplate(
                    cardBody:
                    // Description
                    div.class("text-center w-75 m-auto").child(
                        h4.class("text-dark-50 text-center mt-0 font-weight-bold").child(
                            localize(.title)
                        ),
                        p.class("text-muted mb-4").child(
                            localize(.subtitle)
                        )
                    ) +
                    // Form
                    form.action("/start-reset-password").method(.post).child(

                        // Email
                        div.class("form-group").child(
                            label.for("email").child(
                                localize(.mailTitle)
                            ),
                            input.class("form-control")
                                .type("email")
                                .name("email")
                                .id("email")
                                .placeholder(localize(.mailPlaceholder))
                                .required
                        ),

                        // Login button
                        div.class("form-group mb-0 text-center").child(
                            button.id("submit-button").class("btn btn-primary").type("submit").child(
                                "Gjenopprett passord"
                            )
                        )
                    ),

                    otherActions:
                    // Actions
                    div.class("row mt-3").child(
                        div.class("col-12 text-center").child(
                            p.class("text-muted").child(

                                "Tilbake til ",

                                // Sign up
                                a.href("/login").class("text-dark ml-1").child(
                                    b.child(
                                        "logg inn"
                                    )
                                )
                            )
                        )
                    )
                ),
                withPath: \.base
            )
        }
    }

    public class Mail: LocalizedTemplate {

        public static var localePath: KeyPath<Mail.Context, String>? = \.locale

        public enum LocalizationKeys: String {

            case errorMessage = "error.message"
            case menuRegister = "menu.register"

            case title = "login.title"
            case subtitle = "login.subtitle"

            case mailTitle = "login.mail.title"
            case mailPlaceholder = "login.mail.placeholder"

            case noUserTitle = "login.no.user.title"
            case noUserLink = "login.no.user.link"
        }

        public struct Context {
            let locale = "nb"
            let base: AuthenticationBaseTemplate.Context = .init(
                base: .init(title: "", description: ""),
                message: nil, colorClass: nil
            )
            let user: User
            let changeUrl: String

            public init(user: User, changeUrl: String) {
                self.user = user
                self.changeUrl = changeUrl
            }
        }

        public init() {}

        public func build() -> CompiledTemplate {

            let rootUrl = "uni.kognita.no"

            return embed(
                AuthenticationBaseTemplate(
                    cardBody:
                    // Description
                    div.class("text-center w-75 m-auto").child(
                        h4.class("text-dark-50 text-center mt-0 font-weight-bold").child(
                            "Endre passord"
                        ),
                        p.class("text-muted mb-4").child(
                            "Noen har spurt om å få endre passordet ditt ",
                            variable(\.user.name)
                        )
                    ) +
                    a.href(rootUrl + variable(\.changeUrl)).child(
                        button.class("btn btn-primary").child(
                            "Trykk her for å endre"
                        )
                    ),

                    otherActions: "",

                    rootUrl: rootUrl
                ),
                withPath: \.base
            )
        }
    }

    public struct Reset : LocalizedTemplate {

        public static var localePath: KeyPath<Reset.Context, String>? = \.locale

        public enum LocalizationKeys: String {

            case errorMessage = "error.message"
            case menuRegister = "menu.register"

            case title = "login.title"
            case subtitle = "login.subtitle"

            case passwordTitle = "register.password.title"
            case passwordPlaceholder = "register.password.placeholder"

            case confirmPasswordTitle = "register.password.confirmation.title"
            case confirmPasswordPlaceholder = "register.password.confirmation.placeholder"

            case noUserTitle = "login.no.user.title"
            case noUserLink = "login.no.user.link"
        }

        public struct Context {
            let locale = "nb"
            let base: AuthenticationBaseTemplate.Context
            let token: String

            public init(token: String, alertMessage: (message: String, colorClass: String)? = nil) {
                self.base = .init(
                    base: .init(
                        title: "Gjenopprett Passord",
                        description: "Gjenopprett passord"),
                    message: alertMessage?.message,
                    colorClass: alertMessage?.colorClass
                )
                self.token = token
            }
        }

        public init() {}

        public func build() -> CompiledTemplate {

            return embed(
                AuthenticationBaseTemplate(
                    cardBody:
                    // Description
                    div.class("text-center w-75 m-auto").child(
                        h4.class("text-dark-50 text-center mt-0 font-weight-bold").child(
                            localize(.title)
                        ),
                        p.class("text-muted mb-4").child(
                            localize(.subtitle)
                        )
                    ) +
                    // Form
                    form.action("/reset-password").method(.post).child(

                        // Token
                        input.type("hidden")
                            .name("token")
                            .value(variable(\.token)),

                        // Password
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

                        // Verify Password
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

                        // Login button
                        div.class("form-group mb-0 text-center").child(
                            button.id("submit-button").class("btn btn-primary").type("submit").child(
                                "Gjenopprett passord"
                            )
                        )
                    )

                    ,
                    otherActions: ""
                ),
                withPath: \.base
            )
        }
    }
}
