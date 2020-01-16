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

extension Button {
    public func isRounded(_ condtion: Conditionable = true) -> Button {
        self.modify(if: condtion) {
            $0.class("btn-rounded")
        }
    }
}

struct LogoImage: HTMLComponent {
    var body: HTML {
        Img().source("/assets/images/logo.png").alt("Logo").height(30)
    }
}

struct BaseTemplateContent {
    let title: String
    let description: String

    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
}

struct BaseTemplate: HTMLComponent {

    let context: TemplateValue<BaseTemplateContent>
    let content: HTML
    private var customHeader: HTML = ""
    private var rootUrl: String = ""
    private var customScripts: HTML = ""

    init(context: TemplateValue<BaseTemplateContent>, @HTMLBuilder content: () -> HTML) {
        self.context = context
        self.content = content()
    }

    init(context: TemplateValue<BaseTemplateContent>, content: HTML, customHeader: HTML, rootUrl: String, scripts: HTML) {
        self.content = content
        self.context = context
        self.customHeader = customHeader
        self.rootUrl = rootUrl
        self.customScripts = scripts
    }

    func scripts(@HTMLBuilder scripts: () -> HTML) -> BaseTemplate {
        BaseTemplate(context: context, content: content, customHeader: customHeader, rootUrl: rootUrl, scripts: scripts())
    }

    func header(@HTMLBuilder header: () -> HTML) -> BaseTemplate {
        BaseTemplate(context: context, content: content, customHeader: header(), rootUrl: rootUrl, scripts: customScripts)
    }

    func rootUrl(_ url: String) -> BaseTemplate {
        BaseTemplate(context: context, content: content, customHeader: customHeader, rootUrl: url, scripts: customScripts)
    }

    var body: HTML {
        Document(type: .html5) {
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
            customScripts
        }
    }
}

extension BaseTemplate {
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

struct ContentBaseTemplate: HTMLComponent {

    struct TabContent {
        let link: String
        let iconClass: String
        let title: String
    }

    let activePath: TemplateValue<String>
    let userContext: TemplateValue<User>
    let baseContext: TemplateValue<BaseTemplateContent>

    let content: HTML
    let header: HTML
    let scripts: HTML
    let modals: HTML

    init(userContext: TemplateValue<User>, baseContext: TemplateValue<BaseTemplateContent>, @HTMLBuilder content: () -> HTML) {
        self.userContext = userContext
        self.baseContext = baseContext
        self.content = content()
        self.activePath = ""
        self.header = ""
        self.scripts = ""
        self.modals = ""
    }

    init(base: ContentBaseTemplate, activePath: TemplateValue<String>, header: HTML, scripts: HTML, modals: HTML) {
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


    func active(path: TemplateValue<String>) -> ContentBaseTemplate {
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

        let userContext: TemplateValue<User>
        let activePath: TemplateValue<String>

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
//                    IF(userContext.isCreator) {
//                        self.tab(with: .constant(creatorTab))
//                    }
                    ListItem {
                        Form {
                            Button {
                                "Logg ut"
                            }
                            .type(.submit)
                            .background(color: .primary)
                            .class("nav-link btn")
                        }
                        .method(.post)
                        .action("/logout")
                        .background(color: .primary)
                    }
                    .class("nav-item")
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

        func tab(with tab: TemplateValue<TabContent>) -> HTML {
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
