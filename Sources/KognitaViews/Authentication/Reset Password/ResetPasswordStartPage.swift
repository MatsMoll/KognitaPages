import BootstrapKit

extension User.Templates.ResetPassword {
    public struct Start: HTMLTemplate {

        public struct Context {
            let base: User.Templates.AuthenticateBaseContext

            public enum States {
                case success
                case start
            }

            public init(state: States = .start, showCookieMessage: Bool) {
                switch state {
                case .success:
                    base = .init(
                        title: "Gjenopprett passord",
                        description: "Gjenopprett passord",
                        alertMessage: "Du skal snart få en mail med en link for å gjenopprette passordet ditt",
                        alertStyle: .success,
                        showCookieMessage: showCookieMessage
                    )
                case .start:
                    base = .init(
                        title: "Gjenopprett passord",
                        description: "Gjenopprett passord",
                        showCookieMessage: showCookieMessage
                    )
                }
            }
        }

        public init() {}

        public let context: TemplateValue<Context> = .root()

        public var body: HTML {
            User.Templates.AuthenticateBase(
                context: context.base
            ) {

                Div {
                    Text(Strings.resetPasswordTitle)
                        .class("text-dark-50")
                        .text(alignment: .center)
                        .margin(.zero, for: .top)
                        .font(style: .bold)
                        .style(.heading4)

                    Text(Strings.resetPasswordSubtitle)
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
                            .required()
                            .autofocus()
                    }
                    Div {
                        Button {
                            Strings.resetPasswordButton.localized()
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
}
