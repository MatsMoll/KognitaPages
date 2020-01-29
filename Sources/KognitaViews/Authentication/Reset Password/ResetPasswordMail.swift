import BootstrapKit
import KognitaCore

extension User.ResetPassword.Token.Data {
    var changeUri: String {
        "/reset-password?token=\(token)"
    }
}

extension User.Templates.ResetPassword {

    public struct Mail: HTMLTemplate {

        public struct Context {
            let user: User
            let token: User.ResetPassword.Token.Data

            public init(user: User, token: User.ResetPassword.Token.Data) {
                self.user = user
                self.token = token
            }
        }


        let rootUrl: String

        public init(rootUrl: String) {
            self.rootUrl = rootUrl
        }

        public var body: HTML {
            User.Templates.AuthenticateBase(
                context: TemplateValue<User.Templates.AuthenticateBaseContext>.constant(
                    .init(
                        title: "Gjenopprett Passord",
                        description: "Gjenopprett Passord",
                        errorMessage: nil
                    )
            )) {
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
            .root(url: rootUrl)
        }
    }
}
