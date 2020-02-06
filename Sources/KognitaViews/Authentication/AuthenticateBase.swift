import BootstrapKit
import KognitaCore

extension User {
    public struct Templates {}
}

extension User.Templates {
    public struct ResetPassword {}
}

extension User.Templates {

    struct AuthenticateBaseContext {
        struct AlertMessage {
            let message: String
            let style: BootstrapStyle
        }

        let base: BaseTemplateContent
        let alertMessage: AlertMessage?

        init(title: String, description: String, errorMessage: String?) {
            self.base = .init(title: title, description: description)
            if let errorMessage = errorMessage {
                self.alertMessage = AlertMessage(message: errorMessage, style: .danger)
            } else {
                self.alertMessage = nil
            }
        }

        init(title: String, description: String) {
            self.base = .init(title: title, description: description)
            self.alertMessage = nil
        }

        init(title: String, description: String, alertMessage: String, alertStyle: BootstrapStyle) {
            self.base = .init(title: title, description: description)
            self.alertMessage = AlertMessage(message: alertMessage, style: alertStyle)
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
                                Unwrap(context.alertMessage) { alertMessage in
                                    Alert {
                                        alertMessage.message
                                    }
                                    .background(color: alertMessage.style)
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
