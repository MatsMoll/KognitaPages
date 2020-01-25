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

    struct AuthenticateBase: HTMLComponent {

        let context: TemplateValue<AuthenticateBaseContext>
        var rootUrl: String = ""
        let cardBody: HTML
        var otherActions: HTML = ""

        init(context: TemplateValue<AuthenticateBaseContext>, @HTMLBuilder cardBody: () -> HTML) {
            self.context = context
            self.cardBody = cardBody()
            rootUrl = ""
            otherActions = ""
        }

        init(context: TemplateValue<AuthenticateBaseContext>, cardBody: HTML, rootUrl: String, otherActions: HTML) {
            self.context = context
            self.cardBody = cardBody
            self.rootUrl = rootUrl
            self.otherActions = otherActions
        }

        var body: HTML {
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
                                                LogoImage(rootUrl: rootUrl)
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
            .rootUrl(rootUrl)
        }

        func root(url: String) -> AuthenticateBase {
            .init(context: context, cardBody: cardBody, rootUrl: url, otherActions: otherActions)
        }

        func otherActions(@HTMLBuilder otherActions: () -> HTML) -> AuthenticateBase {
            .init(context: context, cardBody: cardBody, rootUrl: rootUrl, otherActions: otherActions())
        }
    }
}

extension User.Templates {
    public struct ResetPassword {}
}

extension User.Templates.ResetPassword {
    public struct Start: HTMLTemplate {

        public struct Context {
            let base: User.Templates.AuthenticateBaseContext

            public init(errorMessage: String?) {
                base = .init(
                    title: "Gjenopprett passord",
                    description: "Gjenopprett passord",
                    errorMessage: errorMessage
                )
            }
        }

        public init() {}

        public let context: TemplateValue<Context> = .root()

        public var body: HTML {
            User.Templates.AuthenticateBase(
                context: context.base
            ) {

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
                .margin(.auto)

                Form {
                    FormGroup(label: Strings.mailTitle.localized()) {
                        Input()
                            .id("email")
                            .type(.email)
                            .placeholder(localized: Strings.mailPlaceholder)
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
                .method(.post)
            }
            .otherActions {
                Row {
                    Div {
                        Text {
                            "Tilbake til "
                            Anchor {
                                Bold { "innloggingssiden" }
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
            }
        }
    }

    public struct Reset: HTMLTemplate {

        public struct Content {
            let token: String

            public init(token: String, alertMessage: (message: String, colorClass: String)? = nil) {
                self.token = token
            }
        }

        public init() {}

        public var context: TemplateValue<Content> = .root()

        public var body: HTML {
            User.Templates.AuthenticateBase(
                context: TemplateValue<User.Templates.AuthenticateBaseContext>.constant(
                    .init(
                        title: "Gjenopprett passord",
                        description: "Gjenopprett passord",
                        errorMessage: nil
                    )
            )) {

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
                    }
                    FormGroup(label: Strings.registerConfirmPasswordTitle.localized()) {
                        Input()
                            .type(.password)
                            .id("verifyPassword")
                            .placeholder(localized: Strings.registerConfirmPasswordPlaceholder)
                    }
                    
                    Button {
                        "Endre passord"
                    }
                    .type(.submit)
                    .button(style: .primary)
                }
                .action("/reset-password")
                .method(.post)
            }
        }
    }
}
