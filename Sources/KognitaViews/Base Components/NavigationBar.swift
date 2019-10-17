//
//  NavigationBar.swift
//  App
//
//  Created by Mats Mollestad on 26/02/2019.
//
// swiftlint:disable line_length nesting

import HTMLKit
import BootstrapKit

struct BetaHeader: StaticView {

    var body: View {
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

//struct BetaHeader : StaticView {
//
//    func build() -> CompiledTemplate {
//        return div.class("container text-light text-center pt-2").child(
//            p.class("d-inline").child(
//                "🚧👷‍♂️ Dette er en beta versjon av Kognita. Det er bare å prøve den, men vi vil veldig gjerne høre hva du tenker. Du kan kontakte oss via "
//            ),
//            a.class("d-inline text-white").href("mailto: mats@kognita.no").child(
//                "Email"
//            ),
//            p.class("d-inline").child(".")
//        )
//    }
//}

//extension AttributableNode {
//
//    func ariaLabelledby(_ values: CompiledTemplate...) -> Self {
//        return add(.init(attribute: "aria-labelledby", value: values))
//    }
//}

//struct NavigationBar: LocalizedTemplate {
//
//    static var localePath: KeyPath<NoContext, String>?
//
//    enum LocalizationKeys: String {
//        case login = "menu.login"
//        case register = "menu.register"
//    }
//
//    typealias Context = NoContext
//
//    let rootUrl: String
//
//    init(rootUrl: String = "") {
//        self.rootUrl = rootUrl
//    }
//
//    func build() -> CompiledTemplate {
//        return
//            div.class("topnav").child(
//                BetaHeader(),
//                div.class("container").child(
//                    nav.class("navbar navbar-dark navbar-expand-lg topnav-menu").child(
//                        // Logo
//                        a.href(rootUrl + "/").class("logo text-center").child(
//                            span.class("logo-lg").child(
//                                img.src(rootUrl + "/assets/images/logo.png").alt("").height(30)
//                            ),
//                            span.class("logo-sm").child(
//                                img.src(rootUrl + "/assets/images/logo.png").alt("").height(30)
//                            )
//                        ),
//
//                        div.class("collapse navbar-collapse").id("navbarResponsive").child(
//                            ul.class("navbar-nav ml-auto").child(
//                                li.class("nav-item").child(
//                                    a.class("nav-link").href(rootUrl + "/signup").child(
//                                        localize(.register)
//                                    )
//                                ),
//                                li.class("nav-item").child(
//                                    a.class("nav-link").href(rootUrl + "/login").child(
//                                        localize(.login)
//                                    )
//                                )
//                            )
//                        )
//                    )
//                )
//        )
//    }
//}

struct KognitaNavigationBar: StaticView {

    var rootUrl: String = ""

    var body: View {
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
                        UnorderdList {
                            ListItem {
                                Anchor {
                                    "localize(.register)"
                                }.class("nav-link").href(rootUrl + "/signup")
                            }.class("nav-item")
                            ListItem {
                                Anchor {
                                    "localize(.login)"
                                }.class("nav-link").href(rootUrl + "/login")
                            }.class("nav-item")
                        }.class("navbar-nav ml-auto")
                    }.class("collapse navbar-collapse").id("navbarResponsive")
                }.class("navbar navbar-dark navbar-expand-lg topnav-menu")
            }
        }.class("topnav")
    }
}
