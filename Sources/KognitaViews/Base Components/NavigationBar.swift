//
//  NavigationBar.swift
//  App
//
//  Created by Mats Mollestad on 26/02/2019.
//
// swiftlint:disable line_length nesting

import HTMLKit
import BootstrapKit

struct BetaHeader: HTMLComponent {

    var body: HTML {
        Container {
            Text {
                "🚧👷‍♂️ Dette er en betaversjon av Kognita, men du kan gjerne prøve tjenesten allerede nå. Vi vil veldig gjerne ha dine tilbakemeldinger. Kontakt oss via "
            }
            .display(.inline)
            .style(.paragraph)
            .class("text-white-50")
            Anchor {
                "Email"
            }
            .display(.inline)
            .text(color: .white)
            .href("mailto:kontakt@kognita.no")

            Text { "." }
                .display(.inline)
                .style(.paragraph)
                .class("text-white-50")
        }
        .text(alignment: .center)
        .padding(.two, for: .top)
    }
}

struct HyperHamburgerMenu: HTMLComponent, AttributeNode {

    var attributes: [HTMLAttribute]

    init(attributes: [HTMLAttribute] = []) {
        self.attributes = attributes
    }

    var body: HTML {
        Anchor {
            Div {
                Span()
                Span()
                Span()
            }.class("lines")
        }
        .class("navbar-toggle")
        .add(attributes: attributes)
    }

    func copy(with attributes: [HTMLAttribute]) -> HyperHamburgerMenu {
        .init(attributes: attributes)
    }
}

struct KognitaNavigationBar: HTMLComponent {

    var rootUrl: String = ""

    var body: HTML {
        Div {
//            BetaHeader()
            Container {
                NavigationBar {
                    Anchor {
                        Span {
                            LogoImage(rootUrl: rootUrl)
                        }.class("logo-lg")
                        Span {
                            LogoImage(rootUrl: rootUrl)
                        }.class("logo-sm")
                    }
                    .href(rootUrl + "/")
                    .class("logo text-center")

                    NavigationBar.Collapse {
                        ListItem {
                            Anchor(Strings.menuRegister)
                                .class("nav-link")
                                .href(rootUrl + "/signup")
                        }
                        .class("nav-item")
                        ListItem {
                            Anchor(Strings.menuLogin)
                                .class("nav-link")
                                .href(rootUrl + "/login")
                        }
                        .class("nav-item")
                    }
                    .button {
                        HyperHamburgerMenu()
                    }
                }
                .navigationBar(style: .dark)
                .class("topnav-navbar")
            }
        }.class("topnav")
    }
}
