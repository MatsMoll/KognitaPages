//
//  Footer.swift
//  App
//
//  Created by Mats Mollestad on 26/02/2019.
//

import HTMLKit
import BootstrapKit

struct CopyrightFooter: HTMLComponent {

    var body: HTML {
        Footer {
            Container(mode: .fluid) {
                Row {
                    Div {
                        P(Strings.copyright)
                    }
                    .columnWidth(6, for: .medium)
                    Div {
                        Div {
                            Anchor(Strings.footerAboutUs).href("#")
                            Anchor(Strings.footerHelp).href("#")
                            Anchor(Strings.footerContact).href("#")
                        }
                        .text(alignment: .right)
                        .class("footer-links")
                        .display(.none)
                        .display(.block, breakpoint: .medium)
                    }
                    .columnWidth(6, for: .medium)
                }
            }
        }.class("footer")
    }
}

struct KognitaFooter: HTMLComponent, AttributeNode {

    let isDark: Conditionable
    var attributes: [HTMLAttribute]

    init(isDark: Conditionable = false) {
        self.isDark = isDark
        self.attributes = []
    }

    private init(isDark: Conditionable, attributes: [HTMLAttribute]) {
        self.isDark = isDark
        self.attributes = attributes
    }

    var body: HTML {
        Footer {
            Container {
                Row {
                    Div {
                        LogoImage(isDark: isDark)
                        Text {
                            "Kognita gjør det lettere å lære nytt pensum"
                            Break()
                            "Du kan derfor bruke mer tid på det du verdsetter"
                        }
                        .margin(.four, for: .top)
                        .text(color: .muted)
                    }
                    .column(width: .six, for: .large)
                    Div {
                        Text {
                            "Firma"
                        }
                        .style(.heading5)
                        .modify(if: isDark) {
                            $0.text(color: .white)
                        }
                        .modify(if: !isDark) {
                            $0.text(color: .dark)
                        }

                        UnorderedList {
                            ForEach(in: itemLinks) { item in
                                ListItemLink(context: item)
                            }
                        }
                        .class("list-unstyled")
                        .padding(.zero, for: .left)
                        .margin(.zero, for: .bottom)
                        .margin(.three, for: .top)
                    }
                    .column(width: .three, for: .large)
                    .offset(width: .three, for: .large)
                }
                Row {
                    Div {
                        Div {
                            Text(Strings.copyright)
                                .text(color: .muted)
                                .text(alignment: .center)
                                .margin(.four, for: .top)
                        }
                        .margin(.five, for: .top)
                    }
                    .column(width: .twelve, for: .large)
                }
            }
        }
        .padding(.five, for: .vertical)
        .class("border-top border-light")
        .modify(if: isDark) {
            $0.background(color: .dark)
        }
        .modify(if: !isDark) {
            $0.background(color: .white)
        }
        .add(attributes: attributes)
    }

    func copy(with attributes: [HTMLAttribute]) -> KognitaFooter {
        .init(isDark: isDark, attributes: attributes)
    }

    let itemLinks: [ListItemLink.Context] = [
        .init(title: "Om oss", url: "#"),
        .init(title: "Hjelp", url: "#"),
        .init(title: "Brukervilkår", url: "/terms-of-service"),
        .init(title: "Personvern", url: "/privacy-policy"),
        .init(title: "Kontakt oss", url: "mailto:kontakt@kognita.no")
    ]

    struct ListItemLink: HTMLComponent {

        struct Context {
            let title: String
            let url: String
        }

        let context: TemplateValue<Context>

        var body: HTML {
            ListItem {
                Anchor {
                    context.title
                }
                .href(context.url)
                .text(color: .muted)
            }
            .margin(.two, for: .top)
        }
    }
}
