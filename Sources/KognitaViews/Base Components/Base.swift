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

extension BaseTemplate where T == Never {
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

    var body: HTML {
        BaseTemplate(context: baseContext) {
            Div {
                Div {
                    BetaHeader()
                    Container {
                        KognitaNavigationBar(
                            userContext: userContext,
                            activePath: activePath
                        )
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


    struct KognitaNavigationBar: HTMLComponent {

        let userContext: TemplateValue<T, User>
        let activePath: TemplateValue<T, String>

        private let tabs: [TabContent] = [
            .init(link: "/subjects", iconClass: "dripicons-view-list", title: "Oversikt over fag"),
            .init(link: "/practice-sessions/history", iconClass: "dripicons-view-list", title: "Øvinger"),
        ]

        private let creatorTab = TabContent(
            link: "/creator/dashboard",
            iconClass: "dripicons-view-list",
            title: "Lag innhold"
        )

        var body: HTML {
            NavigationBar {
                NavigationBar.Brand(link: "/subjects") {
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
                        self.tab(with: tab)
                    }
                    IF(userContext.isCreator) {
                        self.tab(with: .constant(creatorTab))
                    }
                }
                .button {
                    Anchor {
                        Div {
                            Span()
                            Span()
                            Span()
                        }.class("lines")
                    }.class("navbar-toggle")
                }
            }
            .navigationBar(style: .dark)
            .class("topnav-navbar")
        }

        func tab(with tab: RootValue<TabContent>) -> HTML {
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
    }
}
