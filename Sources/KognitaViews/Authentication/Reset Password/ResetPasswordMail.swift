import BootstrapKit
import KognitaCore

extension User.Templates.ResetPassword {

    public struct Mail: HTMLTemplate {

        public struct Context {
            let user: User
            let changeUrl: String

            public init(user: User, changeUrl: String) {
                self.user = user
                self.changeUrl = changeUrl
            }
        }

        public init() {}

        let rootUrl = "https://kognita.no"

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
                .text(alignment: .center) +

                Anchor {
                    Button {
                        "Trykk her for å endre"
                    }
                    .button(style: .primary)
                }
                .href(context.changeUrl)
            }
            .root(url: rootUrl)
        }
    }
}
