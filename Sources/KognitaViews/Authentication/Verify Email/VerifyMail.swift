import BootstrapKit
import KognitaCore

extension User.VerifyEmail.EmailContent {
    var verifyUri: String {
        "/users/\(userID)/verify?token=\(token)"
    }
}

extension User.Templates {
    public struct VerifyMail: HTMLTemplate {

        public struct Context {
            let authBase: User.Templates.AuthenticateBaseContext
            let token: User.VerifyEmail.EmailContent

            public init(token: User.VerifyEmail.EmailContent) {
                self.authBase = .init(
                    title: "Verifiser eposten din | Kognita",
                    description: "Verifiser eposten din, og få tilgang til alle våre funksjoner",
                    errorMessage: nil
                )
                self.token = token
            }
        }

        let rootUrl: String

        public init(rootUrl: String) {
            self.rootUrl = rootUrl
        }

        public var body: HTML {
            MailTemplate(
                rootUrl: rootUrl,
                title: .constant("Verifiser brukeren din | Kognita"),
                description: .constant("Verifiser brukeren din")
            ) {
                Div {
                    Text {
                        Strings.verifyEmailTitle.localized()
                    }
                    .class("text-dark-50")
                    .text(alignment: .center)
                    .margin(.zero, for: .top)
                    .font(style: .bold)
                    .style(.heading3)

                    Text {
                        Strings.verifyEmailSubtitle.localized()
                    }
                    .text(color: .muted)
                    .margin(.four, for: .bottom)
                    .style(.paragraph)
                }
                .margin(.auto)
                .width(portion: .threeQuarter)
                .text(alignment: .center)

                Div {
                    Anchor {
                        Strings.verifyEmailButton.localized()
                    }
                    .href(rootUrl + context.token.verifyUri)
                    .button(style: .primary)
                }
                .text(alignment: .center)
            }
        }
    }
}
