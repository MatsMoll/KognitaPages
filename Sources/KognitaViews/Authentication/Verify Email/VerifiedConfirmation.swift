import BootstrapKit
import KognitaCore

extension User.Templates {
    public struct VerifiedConfirmation: HTMLPage {

        public init() {}

        public var body: HTML {
            BaseTemplate(
                context: .init(
                    title: "Epost verifisert",
                    description: "Eposten din er nå verifisert"
                )
            ) {
                KognitaNavigationBar()
                Container {

                    Row {
                        Div {
                            Card {
                                Div {
                                    Text {
                                        "Du har nå verifisert eposten din"
                                    }
                                    .style(.heading4)
                                    .font(style: .bold)
                                    .class("text-dark-50")
                                    .margin(.zero, for: .top)

                                    Text {
                                        "Du har nå fullført verifiseringen og kan begynne å bruke Kognita"
                                    }

                                    Div {
                                        Anchor(Strings.loginButton)
                                            .button(style: .primary)
                                            .href("/login")
                                    }
                                    .class("form-group")
                                    .text(alignment: .center)
                                    .margin(.zero, for: .bottom)
                                }
                                .margin(.auto)
                                .width(portion: .threeQuarter)
                                .text(alignment: .center)
                            }
                            .header {
                                Anchor {
                                    Span {
                                        LogoImage()
                                    }
                                }
                                .href("/")
                            }
                            .modifyHeader {
                                $0.background(color: .primary)
                                    .padding(.four, for: .vertical)
                                    .text(alignment: .center)
                            }
                            .modifyBody {
                                $0.padding(.four)
                            }
                        }
                        .column(width: .five, for: .large)
                    }
                    .horizontal(alignment: .center)
                }
                .margin(.five, for: .top)
                .margin(.five, for: .bottom)
            }
        }
    }
}
