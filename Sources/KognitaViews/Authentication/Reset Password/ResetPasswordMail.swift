import BootstrapKit

extension User.ResetPassword.Token {
    var changeUri: String {
        "/reset-password?token=\(token)"
    }
}

extension User.Templates.ResetPassword {

    public struct Mail: HTMLTemplate {

        public struct Context {
            let user: User
            let token: User.ResetPassword.Token

            public init(user: User, token: User.ResetPassword.Token) {
                self.user = user
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
                title: .constant("Gjenopprett passord | Kognita"),
                description: .constant("Gjenopprett passordet ditt")
            ) {
                Div {
                    Text {
                        "Endre passord"
                    }
                    .class("text-dark-50")
                    .text(alignment: .center)
                    .margin(.zero, for: .top)
                    .style(.heading3)
                    .font(style: .bold)

                    Text {
                        "Noen har spurt om å få endre passordet ditt "
                        context.user.username
                    }
                    .style(.paragraph)
                    .text(color: .muted)
                    .margin(.four, for: .bottom)
                }
                .class("w-75 m-auto")
                .text(alignment: .center)

                Div {
                    Anchor {
                        Button {
                            "Trykk her for å endre"
                        }
                        .button(style: .primary)
                    }
                    .href(rootUrl + context.token.changeUri)
                }
                .class("form-group")
                .text(alignment: .center)
            }
        }
    }
}
