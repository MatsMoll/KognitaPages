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
                "🚧👷‍♂️ Dette er en beta versjon av Kognita. Det er bare å prøve den, men vi vil veldig gjerne høre hva du tenker. Du kan kontakte oss via "
            }
            .display(.inline)
            .style(.paragraph)
            Anchor {
                "Email"
            }
            .display(.inline)
            .text(color: .white)
            .href("mailto:mats@kognita.no")

            Text { "." }
                .display(.inline)
                .style(.paragraph)
        }
        .text(color: .light)
        .text(alignment: .center)
        .padding(.two, for: .top)
    }
}

struct KognitaNavigationBar: HTMLComponent {

    var rootUrl: String = ""

    var body: HTML {
        Div {
            BetaHeader()
            Container {
                Nav {
                    Anchor {
                        Span {
                            Img().source(rootUrl + "/assets/images/logo.png").alt("Logo").height(30)
                        }.class("logo-lg")
                        Span {
                            Img().source(rootUrl + "/assets/images/logo.png").alt("Logo").height(30)
                        }.class("logo-sm")
                    }.href(rootUrl + "/").class("logo text-center")
                    Div {
                        UnorderedList {
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
                        }.class("navbar-nav ml-auto")
                    }.class("collapse navbar-collapse").id("navbarResponsive")
                }.class("navbar navbar-dark navbar-expand-lg topnav-menu")
            }
        }.class("topnav")
    }
}
