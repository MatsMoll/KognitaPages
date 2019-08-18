//
//  NavigationBar.swift
//  App
//
//  Created by Mats Mollestad on 26/02/2019.
//
// swiftlint:disable line_length nesting

import HTMLKit

extension AttributableNode {

    func ariaLabelledby(_ values: CompiledTemplate...) -> Self {
        return add(.init(attribute: "aria-labelledby", value: values))
    }
}

struct NavigationBar: LocalizedTemplate {

    static var localePath: KeyPath<NoContext, String>?

    enum LocalizationKeys: String {
        case login = "menu.login"
        case register = "menu.register"
    }

    typealias Context = NoContext

    func build() -> CompiledTemplate {
        return
            div.class("topnav").child(
                div.class("container").child(
                    nav.class("navbar navbar-dark navbar-expand-lg topnav-menu").child(
                        // Logo
                        a.href("/").class("logo text-center").child(
                            span.class("logo-lg").child(
                                img.src("/assets/images/logo.png").alt("").height(30)
                            ),
                            span.class("logo-sm").child(
                                img.src("/assets/images/logo.png").alt("").height(30)
                            )
                        ),

                        div.class("collapse navbar-collapse").id("navbarResponsive").child(
                            ul.class("navbar-nav ml-auto").child(
                                li.class("nav-item").child(
                                    a.class("nav-link").href("/signup").child(
                                        localize(.register)
                                    )
                                ),
                                li.class("nav-item").child(
                                    a.class("nav-link").href("/login").child(
                                        localize(.login)
                                    )
                                )
                            )
                        )
                    )
                )
        )
    }
}
