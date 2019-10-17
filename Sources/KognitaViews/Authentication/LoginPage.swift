//
//  LoginPage.swift
//  App
//
//  Created by Mats Mollestad on 26/02/2019.
//
// swiftlint:disable line_length nesting

import BootstrapKit

public struct LoginPage: TemplateView {

    public struct Context {
        let errorMessage: String?
        let base: BaseTemplateContent

        public init(errorMessage: String? = nil) {
            //           self.base = .init(title: "Logg inn", description: "Logg inn")
            self.base = BaseTemplateContent(title: "Logg inn", description: "Logg inn")
            self.errorMessage = errorMessage
        }
    }

    public init() {}

    public let context: RootValue<Context> = .root()

    public var body: View {
        BaseTemplate(
            context: context.base,
            content:
            KognitaNavigationBar(rootUrl: "") +
            Div {
                Div {
                    Div {
                        Div {
                            IF(context.errorMessage != nil) {
                                Div {
                                    Button {
                                        Span {
                                            "×"
                                        }.aria(for: "hidden", value: "true")
                                    }.type(.button).class("close").data(for: "dismiss", value: "alert").aria(for: "label", value: "Close")
                                    Bold {
                                        "localize(.errorMessage)"
                                    }
                                    context.errorMessage
                                }.class("alert alert-secondary alert-dismissible bg-danger text-white border-0 fade show").role("alert")
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
                                        H4 {
                                            "localize(.title)"
                                        }.class("text-dark-50 text-center mt-0 font-weight-bold")
                                        P {
                                            "localize(.subtitle)"
                                        }.class("text-muted mb-4")
                                    }.class("text-center w-75 m-auto")
                                    Form {
                                        Div {
                                            Label {
                                                "localize(.mailTitle)"
                                            }.for("emailaddress")
                                            Input().class("form-control").type(.email).name("email").id("email").placeholder("localize(.mailPlaceholder)")
                                        }.class("form-group")
                                        Div {
                                            Anchor {
                                                Small {
                                                    "localize(.forgottenPassword)"
                                                }
                                            }.href("/start-reset-password").class("text-muted float-right")
                                            Label {
                                                "localize(.passwordTitle)"
                                            }.for("password")
                                            Input().class("form-control").type(.password).name("password").id("password").placeholder("localize(.passwordPlaceholder)")
                                        }.class("form-group")
                                        Div {
                                            Button {
                                                "localize(.loginButton)"
                                            }.id("submit-button").class("btn btn-primary").type(.submit)
                                        }.class("form-group mb-0 text-center")
                                    }.action("/login").method(.post)
                                }.class("card-body p-4")
                            }.class("card")
                            Div {
                                Div {
                                    P {
                                        "localize(.noUserTitle)" + " "
                                        Anchor {
                                            Bold {
                                                "localize(.noUserLink)"
                                            }
                                        }.href("/signup").class("text-dark ml-1")
                                    }.class("text-muted")
                                }.class("col-12 text-center")
                            }.class("row mt-3")
                        }.class("col-lg-5")
                    }.class("row justify-content-center")
                }.class("container")
            }.class("account-pages mt-5 mb-5")
        )
    }
}

//public class LoginPage: LocalizedTemplate {
//
//    public init() {}
//
//    public static var localePath: KeyPath<LoginPage.Context, String>? = \.locale
//
//    public enum LocalizationKeys: String {
//
//        case errorMessage = "error.message"
//        case menuRegister = "menu.register"
//
//        case title = "login.title"
//        case subtitle = "login.subtitle"
//
//        case mailTitle = "login.mail.title"
//        case mailPlaceholder = "login.mail.placeholder"
//
//        case passwordTitle = "login.password.title"
//        case passwordPlaceholder = "login.password.placeholder"
//
//        case forgottenPassword = "login.forgotpw.link"
//
//        case loginButton = "login.button"
//
//        case noUserTitle = "login.no.user.title"
//        case noUserLink = "login.no.user.link"
//    }
//
//    public struct Context {
//        let locale = "nb"
//        let base: BaseTemplate.Context
//        let errorMessage: String?
//
//        public init(errorMessage: String? = nil) {
//            self.base = .init(title: "Logg inn", description: "Logg inn")
//            self.errorMessage = errorMessage
//        }
//    }
//
//    public func build() -> CompiledTemplate {
//        return embed(
//            BaseTemplate(
//                body:
//
//                NavigationBar(),
//                div.class("account-pages mt-5 mb-5").child(
//                    div.class("container").child(
//                        div.class("row justify-content-center").child(
//                            div.class("col-lg-5").child(
//
//                                // Error Message
//                                renderIf(
//                                    isNotNil: \.errorMessage,
//
//                                    div.class("alert alert-secondary alert-dismissible bg-danger text-white border-0 fade show").role("alert").child(
//                                        button.type("button").class("close").dataDismiss("alert").ariaLabel("Close").child(
//                                            span.ariaHidden("true").child(
//                                                "×"
//                                            )
//                                        ),
//                                        strong.child(
//                                            localize(.errorMessage)
//                                        ),
//                                        variable(\.errorMessage)
//                                    )
//                                ),
//
//                                // Login card
//                                div.class("card").child(
//
//                                    // Logo
//                                    div.class("card-header pt-4 pb-4 text-center bg-primary").child(
//                                        a.href("index.html").child(
//                                            span.child(
//                                                img.src("assets/images/logo.png").alt("").height(30)
//                                            )
//                                        )
//                                    ),
//                                    div.class("card-body p-4").child(
//
//                                        // Description
//                                        div.class("text-center w-75 m-auto").child(
//                                            h4.class("text-dark-50 text-center mt-0 font-weight-bold").child(
//                                                localize(.title)
//                                            ),
//                                            p.class("text-muted mb-4").child(
//                                                localize(.subtitle)
//                                            )
//                                        ),
//
//                                        // Form
//                                        form.action("/login").method(.post).child(
//
//                                            // Email
//                                            div.class("form-group").child(
//                                                label.for("emailaddress").child(
//                                                    localize(.mailTitle)
//                                                ),
//                                                input.class("form-control")
//                                                    .type("email")
//                                                    .name("email")
//                                                    .id("email")
//                                                    .placeholder(localize(.mailPlaceholder))
//                                                    .required
//                                            ),
//
//                                            // Password
//                                            div.class("form-group").child(
//                                                a.href("/start-reset-password").class("text-muted float-right").child(
//                                                    small.child(
//                                                        localize(.forgottenPassword)
//                                                    )
//                                                ),
//                                                label.for("password").child(
//                                                    localize(.passwordTitle)
//                                                ),
//                                                input.class("form-control")
//                                                    .type("password")
//                                                    .name("password")
//                                                    .id("password")
//                                                    .placeholder(localize(.passwordPlaceholder))
//                                                    .required
//                                            ),
//
//                                            // Login button
//                                            div.class("form-group mb-0 text-center").child(
//                                                button.id("submit-button").class("btn btn-primary").type("submit").child(
//                                                    localize(.loginButton)
//                                                )
//                                            )
//                                        )
//                                    )
//                                ),
//
//                                // Actions
//                                div.class("row mt-3").child(
//                                    div.class("col-12 text-center").child(
//                                        p.class("text-muted").child(
//
//                                            localize(.noUserTitle) + " ",
//
//                                            // Sign up
//                                            a.href("/signup").class("text-dark ml-1").child(
//                                                b.child(
//                                                    localize(.noUserLink)
//                                                )
//                                            )
//                                        )
//                                    )
//                                )
//                            )
//                        )
//                    )
//                )
//            ),
//            withPath: \.base)
//    }
//}

//public struct LoginPage: TemplateView {
//
//    public struct Context {
//        let errorMessage: String?
//        let base: BaseTemplateContent
//
//        public init(errorMessage: String? = nil) {
//            //           self.base = .init(title: "Logg inn", description: "Logg inn")
//            self.base = BaseTemplate<Void>.Context.init(title: "Logg inn", description: "Logg inn")
//            self.errorMessage = errorMessage
//        }
//    }
//
//    public init() {}
//
//    public let context: RootValue<Context> = .root()
//
//    public var body: View {
//        BaseTemplate(
//            context: context.base,
//            content:
//            Div {
//                Container {
//                    Row {
//                        Div {
//                            IF(context.errorMessage != nil) {
//                                Alert {
//                                    context.errorMessage
//                                }
//                                .isDismissable(true)
//                                .style(.danger)
//                            }
//                            Card(image: Img(source: "/assets/images/logo.png")) {
//                                Div {
//                                    "Description"
//                                }
//                                Form {
//                                    FormGroup(
//                                        label: "Epost",
//                                        Input(type: .email, id: "email")
//                                    )
//                                    FormGroup(
//                                        label: "Password",
//                                        Input(type: .password, id: "password")
//                                    )
//                                    Div {
//                                        Button {
//                                            "Login Button"
//                                        }
//                                        .type(.submit)
//                                        .style(.primary)
//                                        .id("submit-button")
//                                    }.class("form-group mb-0 text-center")
//                                }
//                                .action("/login")
//                                .method(.post)
//                                .padding(.all, size: 2)
//                            }
//                        }.columnWidth(5, for: .large)
//                    }.class("justify-content-center")
//                }
//            }
//        )
//    }
//}
