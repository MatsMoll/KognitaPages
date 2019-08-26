//
//  Base.swift
//  App
//
//  Created by Mats Mollestad on 06/02/2019.
//
// swiftlint:disable line_length nesting

import HTMLKit
import KognitaCore

struct BaseTemplate: ContextualTemplate {

    struct Context {
        let title: String
        let description: String

        init(title: String, description: String) {
            self.title = title
            self.description = description
        }
    }

    let body: CompiledTemplate
    let customHeader: CompiledTemplate

    init(body: CompiledTemplate..., customHeader: CompiledTemplate = "") {
        self.body = body
        self.customHeader = customHeader
    }

    func build() -> CompiledTemplate {
        return
            HTMLDocument(
                content:

                head.child(
                    meta.charset("utf-8"),
                    title.child(
                        variable(\.title), " | Kognita"
                    ),
                    meta.name("viewport").content("width=device-width, initial-scale=1.0"),
                    meta.name("description").content(
                        variable(\.description)
                    ),
                    meta.name("author").content("MEM"),

                    link.rel("shortcut icon").href("/assets/images/favicon.ico"),

                    link.href("/assets/css/icons.min.css").rel("stylesheet").type("text/css"),
                    link.href("/assets/css/app.min.css").rel("stylesheet").type("text/css"),

                    customHeader
                ),
                body.child(
                    body
                )
        )
    }
}

struct ContentBaseTemplate: LocalizedTemplate {

    static var localePath: KeyPath<ContentBaseTemplate.Context, String>?

    enum LocalizationKeys: String {
        case overviewMenu = "menu.overview"
        case sessionHistoryMenu = "menu.history"
        case createContentTab = "menu.create"
        case logout = "menu.logout"
    }

    struct Context {
        let base: BaseTemplate.Context
        let user: User

        init(user: User, title: String, description: String = "Gjøre det enklere å lære") {
            self.base = .init(title: title, description: description)
            self.user = user
        }
    }

    let body: CompiledTemplate
    let headerLinks: CompiledTemplate
    let scripts: CompiledTemplate
    let modals: CompiledTemplate

    init(body: CompiledTemplate..., headerLinks: CompiledTemplate = "", scripts: CompiledTemplate = "", modals: CompiledTemplate = "") {
        self.body = body
        self.headerLinks = headerLinks
        self.scripts = scripts
        self.modals = modals
    }

    func build() -> CompiledTemplate {
        return embed(
            BaseTemplate(
                body:
                div.class("wrapper").child(

                    // Topbar
                    div.class("topnav").child(
                        BetaHeader(),
                        div.class("container").child(
                            nav.class("navbar navbar-dark navbar-expand-lg topnav-navbar").child(

                                a.class("navbar-toggle").dataToggle("collapse").dataTarget("#navbarResponsive").ariaExpanded(false).child(
                                    div.class("lines").child(
                                        span,
                                        span,
                                        span
                                    )
                                ),

                                // Logo
                                a.href("/subjects").class("logo text-center").child(
                                    span.class("logo-lg").child(
                                        img.src("/assets/images/logo.png").alt("").height(30)
                                    ),
                                    span.class("logo-sm").child(
                                        img.src("/assets/images/logo.png").alt("").height(30)
                                    )
                                ),

                                div.class("collapse navbar-collapse").id("navbarResponsive").child(
                                    ul.class("navbar-nav ml-auto").child(

                                        // Subject tab
                                        li.class("nav-item").child(
                                            a.href("/subjects").class("nav-link").child(
                                                span.child(
                                                    i.class("dripicons-view-list"),
                                                    " " + localize(.overviewMenu)
                                                )
                                            )
                                        ),

                                        // Practice session
                                        li.class("nav-item").child(
                                            a.href("/practice-sessions/history").class("nav-link").child(
                                                span.child(
                                                    i.class("dripicons-view-list"),
                                                    " " + localize(.sessionHistoryMenu)
                                                )
                                            )
                                        ),

                                        // Create content
                                        renderIf(
                                            \.user.isCreator,

                                            li.class("nav-item").child(
                                                a.href("/creator/dashboard").class("nav-link").child(
                                                    span.child(
                                                        i.class("dripicons-view-list"),
                                                        " " + localize(.createContentTab)
                                                    )
                                                )
                                            )
                                        )
                                    ),
                                    li.class("dropdown notification-list").child(
                                        a.class("nav-link dropdown-toggle nav-user arrow-none mr-0").style("background-color: transparent; color: white; border: none;").dataToggle("dropdown").href("#").role("button").ariaHaspopup("false").ariaExpanded("false").child(
                                            span.class("account-user-avatar").child(
                                                img.src("/assets/images/users/avatar-1.jpg").alt("user-image").class("rounded-circle")
                                            ),
                                            span.child(
                                                span.class("account-user-name").child(
                                                    variable(\.user.name)
                                                ),
                                                span.class("account-position").child(
                                                    variable(\.user.email)
                                                )
                                            )
                                        ),
                                        div.class("dropdown-menu dropdown-menu-right dropdown-menu-animated profile-dropdown").child(

                                            form.class("dropdown-item notify-item").action("/logout").method(.post).child(
                                                i.class("mdi mdi-lock"),
                                                input.class("btn bg-transparent")
                                                    .type("submit")
                                                    .value(localize(.logout))
                                            )
                                        )
                                    )
                                )
                            )
                        )
                    ),

                    // Body

                    div.class("content").child(
                        div.class("container").child(
                            body
                        ),
                        Footer()
                    )
                ),
                modals,

                script.src("/assets/js/app.min.js").type("text/javascript"),
                scripts,

                customHeader: headerLinks
            ),
            withPath: \.base)
    }
}
