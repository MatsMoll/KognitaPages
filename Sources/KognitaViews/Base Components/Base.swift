//
//  Base.swift
//  App
//
//  Created by Mats Mollestad on 06/02/2019.
//
// swiftlint:disable line_length nesting

import HTMLKit
import BootstrapKit
import KognitaCore

struct BaseTemplateContent {
    let title: String
    let description: String

    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
}

struct BaseTemplate<T>: StaticView {

    let context: TemplateValue<T, BaseTemplateContent>
    let content: View
    var customHeader: View = ""
    var rootUrl: String = ""
    var scripts: View = ""

    var body: View {
        "<!DOCTYPE html>" +
        HTMLNode {
            Head {
                Title { context.title + " | Kognita" }

                Meta().name("viewport").content("width=device-width, initial-scale=1.0")
                Meta().name("description").content(context.description)
                Meta().name("author").content("MEM")

                Link().relationship("shortcut icon").href(rootUrl + "/assets/images/favicon.ico")
                Link().relationship("stylesheet").href(rootUrl + "/assets/css/icons.min.css").type("text/css")
                Link().relationship("stylesheet").href(rootUrl + "/assets/css/app.min.css").type("text/css")

                customHeader
            }
            Body {
                content
            }
            Script().source("/assets/js/app.min.js").type("text/javascript")
            scripts
        }
    }
}

struct ContentBaseTemplateContent {
    let base: BaseTemplateContent
    let user: User

    init(user: User, title: String, description: String = "") {
        self.base = .init(title: title, description: description)
        self.user = user
    }
}

struct ContentBaseTemplate<T>: StaticView {

    struct TabContent {
        let link: String
        let iconClass: String
        let title: String
    }

    let userContext: TemplateValue<T, User>
    let baseContext: TemplateValue<T, BaseTemplateContent>

    let content: View
    var headerLinks: [Link] = []
    var scripts: [View] = []
    var modals: View = ""
    private let tabs: RootValue<[TabContent]> = .constant([
        .init(link: "/subjects", iconClass: "dripicons-view-list", title: "Oversikt over fag"),
        .init(link: "/practice-sessions/history", iconClass: "dripicons-view-list", title: "Øvinger"),
    ])

    var body: View {
        BaseTemplate(
            context: baseContext,
            content:
            Div {
                Div {
                    BetaHeader()
                    Container {
                        NavigationBar(expandOn: .large) {
                            NavigationBar.Brand(link: "/") {
                                Span {
                                    Img(source: "/assets/images/logo.png").height(30)
                                }.class("logo-lg")
                                Span {
                                    Img(source: "/assets/images/logo.png").height(30)
                                }.class("logo-sm")
                            }
                            .class("logo")

                            NavigationBar.Collapse {
                                ForEach(in: tabs) { tab in
                                    ListItem {
                                        Anchor {
                                            Span {
                                                Italic().class(tab.iconClass)
                                                " "
                                                tab.title
                                            }
                                        }
                                        .href(tab.link)
                                        .class("nav-link")
                                    }
                                    .class("nav-item")
                                }
                                IF(userContext.isCreator) {
                                    ListItem {
                                        Anchor {
                                            Span {
                                                Italic().class("dripicons-view-list")
                                                " "
                                                "Lag innhold"
                                            }
                                        }.href("/creator/dashboard").class("nav-link")
                                    }.class("nav-item")
                                }
                            }
                        }
                        .navigationBar(style: .dark)
                        .class("topnav-navbar")
                    }
                }.class("topnav")

                Div {
                    Container {
                        content
                    }
                    CopyrightFooter()
                }.class("content")
            }.class("wrapper") +

            modals,

            customHeader:
            headerLinks.reduce("", +),

            scripts: scripts
        )
    }
}

//struct ContentBaseTemplate: LocalizedTemplate {
//
//    static var localePath: KeyPath<ContentBaseTemplate.Context, String>?
//
//    enum LocalizationKeys: String {
//        case overviewMenu = "menu.overview"
//        case sessionHistoryMenu = "menu.history"
//        case createContentTab = "menu.create"
//        case logout = "menu.logout"
//    }
//
//    struct Context {
//        let base: BaseTemplate.Context
//        let user: User
//
//        init(user: User, title: String, description: String = "Gjøre det enklere å lære") {
//            self.base = .init(title: title, description: description)
//            self.user = user
//        }
//    }
//
//    let body: CompiledTemplate
//    let headerLinks: CompiledTemplate
//    let scripts: CompiledTemplate
//    let modals: CompiledTemplate
//
//    init(body: CompiledTemplate..., headerLinks: CompiledTemplate = "", scripts: CompiledTemplate = "", modals: CompiledTemplate = "") {
//        self.body = body
//        self.headerLinks = headerLinks
//        self.scripts = scripts
//        self.modals = modals
//    }
//
//    func build() -> CompiledTemplate {
//        return embed(
//            BaseTemplate(
//                body:
//                div.class("wrapper").child(
//
//                    // Topbar
//                    div.class("topnav").child(
//                        BetaHeader(),
//                        div.class("container").child(
//                            nav.class("navbar navbar-dark navbar-expand-lg topnav-navbar").child(
//
//                                a.class("navbar-toggle").dataToggle("collapse").dataTarget("#navbarResponsive").ariaExpanded(false).child(
//                                    div.class("lines").child(
//                                        span,
//                                        span,
//                                        span
//                                    )
//                                ),
//
//                                // Logo
//                                a.href("/subjects").class("logo text-center").child(
//                                    span.class("logo-lg").child(
//                                        img.src("/assets/images/logo.png").alt("").height(30)
//                                    ),
//                                    span.class("logo-sm").child(
//                                        img.src("/assets/images/logo.png").alt("").height(30)
//                                    )
//                                ),
//
//                                div.class("collapse navbar-collapse").id("navbarResponsive").child(
//                                    ul.class("navbar-nav ml-auto").child(
//
//                                        // Subject tab
//                                        li.class("nav-item").child(
//                                            a.href("/subjects").class("nav-link").child(
//                                                span.child(
//                                                    i.class("dripicons-view-list"),
//                                                    " " + localize(.overviewMenu)
//                                                )
//                                            )
//                                        ),
//
//                                        // Practice session
//                                        li.class("nav-item").child(
//                                            a.href("/practice-sessions/history").class("nav-link").child(
//                                                span.child(
//                                                    i.class("dripicons-view-list"),
//                                                    " " + localize(.sessionHistoryMenu)
//                                                )
//                                            )
//                                        ),
//
//                                        // Create content
//                                        renderIf(
//                                            \.user.isCreator,
//
//                                            li.class("nav-item").child(
//                                                a.href("/creator/dashboard").class("nav-link").child(
//                                                    span.child(
//                                                        i.class("dripicons-view-list"),
//                                                        " " + localize(.createContentTab)
//                                                    )
//                                                )
//                                            )
//                                        )
//                                    ),
//                                    li.class("dropdown notification-list").child(
//                                        a.class("nav-link dropdown-toggle nav-user arrow-none mr-0").style("background-color: transparent; color: white; border: none;").dataToggle("dropdown").href("#").role("button").ariaHaspopup("false").ariaExpanded("false").child(
//                                            span.class("account-user-avatar").child(
//                                                img.src("/assets/images/users/avatar-1.jpg").alt("user-image").class("rounded-circle")
//                                            ),
//                                            span.child(
//                                                span.class("account-user-name").child(
//                                                    variable(\.user.name)
//                                                ),
//                                                span.class("account-position").child(
//                                                    variable(\.user.email)
//                                                )
//                                            )
//                                        ),
//                                        div.class("dropdown-menu dropdown-menu-right dropdown-menu-animated profile-dropdown").child(
//
//                                            form.class("dropdown-item notify-item").action("/logout").method(.post).child(
//                                                i.class("mdi mdi-lock"),
//                                                input.class("btn bg-transparent")
//                                                    .type("submit")
//                                                    .value(localize(.logout))
//                                            )
//                                        )
//                                    )
//                                )
//                            )
//                        )
//                    ),
//
//                    // Body
//
//                    div.class("content").child(
//                        div.class("container").child(
//                            body
//                        ),
//                        Footer()
//                    )
//                ),
//                modals,
//
//                script.src("/assets/js/app.min.js").type("text/javascript"),
//                scripts,
//
//                customHeader: headerLinks
//            ),
//            withPath: \.base)
//    }
//}
