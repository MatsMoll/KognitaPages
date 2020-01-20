import BootstrapKit
import KognitaCore

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
                }
                .class("topnav")

                Div {
                    Container {
                        content
                    }
                }
                .class("content")

                KognitaFooter()
                    .margin(.three, for: .top)
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
                        LogoImage()
                    }.class("logo-lg")
                    Span {
                        LogoImage()
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

