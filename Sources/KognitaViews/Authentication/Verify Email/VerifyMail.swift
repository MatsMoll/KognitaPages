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
            AuthenticateBase(
                context: context.authBase
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
                .margin(.auto)
                .width(portion: .threeQuarter)
                .text(alignment: .center)

                Anchor {
                    "Verifiser nå"
                }
                .href(rootUrl + context.token.verifyUri)
                .button(style: .primary)
            }
            .root(url: rootUrl)
        }
    }
}
