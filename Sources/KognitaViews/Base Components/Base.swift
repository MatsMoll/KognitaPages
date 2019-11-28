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

struct BaseTemplate<T>: HTMLComponent {

    let context: TemplateValue<T, BaseTemplateContent>
    let content: HTML
    var customHeader: HTML = ""
    var rootUrl: String = ""
    var scripts: HTML = ""

    init(context: TemplateValue<T, BaseTemplateContent>, @HTMLBuilder content: () -> HTML) {
        self.context = context
        self.content = content()
    }

    init(context: TemplateValue<T, BaseTemplateContent>, content: HTML, customHeader: HTML, rootUrl: String, scripts: HTML) {
        self.content = content
        self.context = context
        self.customHeader = customHeader
        self.rootUrl = rootUrl
        self.scripts = scripts
    }

    func scripts(@HTMLBuilder scripts: () -> HTML) -> BaseTemplate {
        BaseTemplate(context: context, content: content, customHeader: customHeader, rootUrl: rootUrl, scripts: scripts())
    }

    func header(@HTMLBuilder header: () -> HTML) -> BaseTemplate {
        BaseTemplate(context: context, content: content, customHeader: header(), rootUrl: rootUrl, scripts: scripts)
    }

    func rootUrl(_ url: String) -> BaseTemplate {
        BaseTemplate(context: context, content: content, customHeader: customHeader, rootUrl: url, scripts: scripts)
    }

    var body: HTML {
        Document(type: .html5) {
            HTMLNode {
                Head {
                    Title { context.title + " | Kognita" }

                    Meta().name(.viewport).content("width=device-width, initial-scale=1.0")
                    Meta().name(.description).content(context.description)
                    Meta().name(.author).content("MEM")

                    Link().relationship(.shortcutIcon).href(rootUrl + "/assets/images/favicon.ico")
                    Link().relationship(.stylesheet).href(rootUrl + "/assets/css/icons.min.css").type("text/css")
                    Link().relationship(.stylesheet).href(rootUrl + "/assets/css/app.min.css").type("text/css")

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
}

extension BaseTemplate where T == BaseTemplateContent {
    init(context: BaseTemplateContent, @HTMLBuilder content: () -> HTML) {
        self.context = .constant(context)
        self.content = content()
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

struct ContentBaseTemplate<T>: HTMLComponent {

    struct TabContent {
        let link: String
        let iconClass: String
        let title: String
    }

    let activePath: TemplateValue<T, String>
    let userContext: TemplateValue<T, User>
    let baseContext: TemplateValue<T, BaseTemplateContent>

    let content: HTML
    let header: HTML
    let scripts: HTML
    let modals: HTML

    init(userContext: TemplateValue<T, User>, baseContext: TemplateValue<T, BaseTemplateContent>, @HTMLBuilder content: () -> HTML) {
        self.userContext = userContext
        self.baseContext = baseContext
        self.content = content()
        self.activePath = ""
        self.header = ""
        self.scripts = ""
        self.modals = ""
    }

    init(base: ContentBaseTemplate, activePath: TemplateValue<T, String>, header: HTML, scripts: HTML, modals: HTML) {
        self.userContext = base.userContext
        self.baseContext = base.baseContext
        self.content = base.content
        self.activePath = activePath
        self.header = header
        self.scripts = scripts
        self.modals = modals
    }

    func active(path: TemplateValue<T, String>) -> ContentBaseTemplate {
        ContentBaseTemplate(base: self, activePath: path, header: header, scripts: scripts, modals: modals)
    }

    func header(@HTMLBuilder _ header: () -> HTML) -> ContentBaseTemplate {
        ContentBaseTemplate(base: self, activePath: activePath, header: header(), scripts: scripts, modals: modals)
    }

    func scripts(@HTMLBuilder _ scripts: () -> HTML) -> ContentBaseTemplate {
        ContentBaseTemplate(base: self, activePath: activePath, header: header, scripts: scripts(), modals: modals)
    }

    func modals(@HTMLBuilder _ modals: () -> HTML) -> ContentBaseTemplate {
        ContentBaseTemplate(base: self, activePath: activePath, header: header, scripts: scripts, modals: modals())
    }

    private let tabs: RootValue<[TabContent]> = .constant([
        .init(link: "/subjects", iconClass: "dripicons-view-list", title: "Oversikt over fag"),
        .init(link: "/practice-sessions/history", iconClass: "dripicons-view-list", title: "Øvinger"),
    ])

    var body: HTML {
        BaseTemplate(context: baseContext) {
            Div {
                Div {
                    BetaHeader()
                    Container {
                        NavigationBar(expandOn: .large) {
                            NavigationBar.Brand(link: "/subjects") {
                                Span {
                                    Img(source: "/assets/images/logo.png").height(30)
                                }.class("logo-lg")
                                Span {
                                    Img(source: "/assets/images/logo.png").height(30)
                                }.class("logo-sm")
                            }
                            .class("logo")

                            NavigationBar.Collapse(button:
                                Anchor {
                                    Div {
                                        Span()
                                        Span()
                                        Span()
                                    }.class("lines")
                                }.class("navbar-toggle")
                            ) {
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
                                    .modify(if: tab.link == activePath) {
                                        $0.class("active")
                                    }
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
                                    }
                                    .class("nav-item")
                                    .modify(if: activePath == "/creator/dashboard") {
                                        $0.class("active")
                                    }
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
            }.class("wrapper")

            modals
        }
        .header {
            header
        }
        .scripts {
            scripts
        }
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
