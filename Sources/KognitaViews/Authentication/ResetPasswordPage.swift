//
//  ResetPasswordPage.swift
//  KognitaViews
//
//  Created by Mats Mollestad on 9/4/19.
//

import BootstrapKit
import KognitaCore

extension User {
    public struct Templates {}
}

extension User.Templates {

    struct AuthenticateBaseContext {
        let base: BaseTemplateContent
        let errorMessage: String?

        init(title: String, description: String, errorMessage: String?) {
            self.base = .init(title: title, description: description)
            self.errorMessage = errorMessage
        }
    }

    struct AuthenticateBase<T>: StaticView {

        let context: TemplateValue<T, AuthenticateBaseContext>
        var rootUrl: String = ""
        let cardBody: View
        var otherActions: View = ""

        var body: View {
            BaseTemplate(context: context.base) {
                KognitaNavigationBar(rootUrl: rootUrl)
                Div {
                    Container {
                        Row {
                            Div {
                                IF(context.errorMessage != nil) {
                                    Alert {
                                        context.errorMessage
                                    }
                                    .background(color: .danger)
                                    .text(color: .white)
                                    .isDismissable(true)
                                }
                                Div {
                                    Div {
                                        Anchor {
                                            Span {
                                                Img().source(rootUrl + "/assets/images/logo.png").alt("").height(30)
                                            }
                                        }
                                        .href("/")
                                    }
                                    .class("card-header")
                                    .padding(.four, for: .top)
                                    .padding(.four, for: .bottom)
                                    .text(alignment: .center)
                                    .background(color: .primary)

                                    Div {
                                        cardBody
                                    }
                                    .class("card-body")
                                    .padding(.four)
                                }
                                .class("card")

                                otherActions
                            }
                            .column(width: .five, for: .large)
                        }
                        .class("justify-content-center")
                    }
                }
                .margin(.five, for: .top)
                .margin(.five, for: .bottom)
                .class("account-pages")
            }
        }
    }
}

extension User.Templates {
    public struct ResetPassword {}
}

extension User.Templates.ResetPassword {
    public struct Start: TemplateView {

        public struct Context {
            let base: User.Templates.AuthenticateBaseContext

            public init(errorMessage: String?) {
                base = .init(
                    title: "Gjenopprett Passord",
                    description: "Gjenopprett Passord",
                    errorMessage: errorMessage
                )
            }
        }

        public init() {}

        public let context: RootValue<Context> = .root()

        public var body: View {
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
                    .style(.paragraph)
                }
                .class("w-75")
                .text(alignment: .center)
                .margin(.auto) +

                Form {
                    FormGroup(label: "localize(.mailTitle)") {
                        Input()
                            .id("email")
                            .type(.email)
                            .placeholder("localize(.mailPlaceholder)")
                    }
                    Div {
                        Button {
                            "Gjenopprett passord"
                        }
                        .id("submit-button")
                        .button(style: .primary)
                        .type(.submit)
                    }
                    .class("form-group")
                    .text(alignment: .center)
                    .margin(.zero, for: .bottom)
                }
                .action("/start-reset-password")
                .method(.post),

                otherActions:
                Row {
                    Div {
                        Text {
                            "Tilbake til "
                            Anchor {
                                Bold { "logg inn" }
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
            )
        }
    }

    public struct Mail: TemplateView {

        public struct Context {
            let user: User
            let changeUrl: String

            public init(user: User, changeUrl: String) {
                self.user = user
                self.changeUrl = changeUrl
            }
        }

        public init() {}

        public let context: RootValue<Context> = .root()
        let rootUrl = "uni.kognita.no"

        public var body: View {
            User.Templates.AuthenticateBase(
                context: RootValue<User.Templates.AuthenticateBaseContext>.constant(
                    .init(
                        title: "Gjenopprett Passord",
                        description: "Gjenopprett Passord",
                        errorMessage: nil
                    )
                ),
                rootUrl: rootUrl,
                cardBody:
                Div {
                    Text {
                        "Endre passord"
                    }
                    .class("text-dark-50")
                    .text(alignment: .center)
                    .margin(.zero, for: .top)
                    .style(.heading4)
                    .font(style: .bold)

                    Text {
                        "Noen har spurt om å få endre passordet ditt "
                        context.user.name
                    }
                    .style(.paragraph)
                    .text(color: .muted)
                    .margin(.four, for: .bottom)
                }
                .class("w-75 m-auto")
                .text(alignment: .center) +

                Anchor {
                    Button {
                        "Trykk her for å endre"
                    }
                    .button(style: .primary)
                }
                .href(rootUrl + context.changeUrl)
            )
        }
    }

    public struct Reset: TemplateView {

        public struct Content {
            let token: String

            public init(token: String, alertMessage: (message: String, colorClass: String)? = nil) {
                self.token = token
            }
        }

        public init() {}

        public var context: RootValue<Content> = .root()

        public var body: View {
            User.Templates.AuthenticateBase(
                context: RootValue<User.Templates.AuthenticateBaseContext>.constant(
                    .init(
                        title: "Gjenopprett Passord",
                        description: "Gjenopprett Passord",
                        errorMessage: nil
                    )
                ),
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
                    .style(.paragraph)
                }
                .margin(.auto)
                .width(portion: .threeQuarter)
                .text(alignment: .center) +

                Form {
                    Input()
                        .type(.hidden)
                        .name("token")
                        .value(context.token)
                    FormGroup(label: "localize(.passwordTitle)") {
                        Input()
                            .type(.password)
                            .id("password")
                            .placeholder("localize(.passwordPlaceholder)")
                    }
                    FormGroup(label: "localize(.passwordTitle)") {
                        Input()
                            .type(.password)
                            .id("verifyPassword")
                            .placeholder("localize(.confirmPasswordPlaceholder)")
                    }
                }
                .action("/reset-password")
                .method(.post)
            )
        }
    }
}
