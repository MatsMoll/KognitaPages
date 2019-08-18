//
//  Sidebar.swift
//  App
//
//  Created by Mats Mollestad on 26/02/2019.
//
// swiftlint:disable line_length nesting

import HTMLKit

struct Sidebar: StaticView {

    func build() -> CompiledTemplate {
        return
            div.class("left-side-menu").child(
                div.class("slimscroll-menu").child(

                    // Logo
                    a.href("/").class("logo text-center").child(
                        span.class("logo-lg").child(
                            img.src("/assets/images/logo.png").alt("").height(30)
                        ),
                        span.class("logo-sm").child(
                            img.src("/assets/images/logo_sm.png").alt("").height(30)
                        )
                    ),

                    // Side menu
                    ul.class("metismenu side-nav").child(
                        li.class("side-nav-title side-nav-item").child("Navigation"),
                        li.class("side-nav-item").child(
                            a.href("/").class("side-nav-link").child(
                                span.child(
                                    i.class("dripicons-home"),
                                    "Dashboard ",
                                    small.child(
                                        " Kommer snart"
                                    )
                                )
                            )
                        ),
                        li.class("side-nav-item").child(
                            a.href("/subjects").class("side-nav-link").child(
                                span.child(
                                    i.class("dripicons-book"),
                                    " Faginnhold"
                                )
                            )
                        ),
                        li.class("side-nav-item").child(
                            a.href("/results").class("side-nav-link").child(
                                span.child(
                                    i.class("dripicons-dashboard"),
                                    " Test Resultater"
                                )
                            )
                        )
                    ),

                    // Help box
                    div.class("help-box text-white text-center").child(
                        a.href("javascript:%20void(0);").class("float-right close-btn text-white"),
                        img.src("/assets/images/help-icon.svg").height(90).alt("Helper Icon Image"),
                        h5.class("mt-3").child(
                            "Unlimited Access"
                        ),
                        p.class("mb-3").child(
                            "Upgrade to plan to get access to unlimited reports"
                        ),
                        a.href("javascript:%20void(0);").class("btn btn-outline-light btn-sm").child(
                            "Upgrade"
                        )
                    ),
                    div.class("clearfix")
                )
        )
    }
}
