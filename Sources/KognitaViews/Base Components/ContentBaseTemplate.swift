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

struct HyperNavbar: HTMLComponent {
    var body: HTML {
        NodeList {
            Div {
                Anchor {
                    Span {
                        LogoImage()
                    }
                    .class("topnav-logo-lg")
                    Span {
                        LogoImage()
                    }
                    .class("topnav-logo-sm")
                }
                .class("topnav-logo")
                Anchor {
                    Div {
                        Span()
                        Span()
                        Span()
                    }
                    .class("lines")
                }
                .class("navbar-toggle open")
                .data("toggle", value: "collapse")
                .data("target", value: "#topnav-menu-content")
                .aria("expanded", value: false)
            }
            .class("navbar-custom topnav-navbar")
            Div {
                Div {
                    Nav {
                        Div {
                            UnorderedList {
                                ListItem {
                                    "HEllo"
                                }
                                .class("nav-item dropdown")
                            }
                            .class("navbar-nav")
                        }
                        .class("collapse navbar-collapse active")
                        .id("topnav-menu-content")
                    }
                    .class("navbar navbar-dark navbar-expand-lg topnav-menu")
                }
                .class("container-fluid active")
            }
            .class("topnav")
        }
    }
}

struct ContentBaseTemplate: HTMLComponent {

    struct TabContent {
        let link: String
        let icon: MaterialDesignIcon.Icons
        let title: ViewWrapper
    }

    let activePath: TemplateValue<String>
    let userContext: TemplateValue<User>
    let baseContext: TemplateValue<BaseTemplateContent>
    let scrollSpy: ScrollSpy?

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
        self.scrollSpy = nil
    }

    private init(base: ContentBaseTemplate, activePath: TemplateValue<String>, header: HTML, scripts: HTML, modals: HTML, scrollSpy: ScrollSpy?) {
        self.userContext = base.userContext
        self.baseContext = base.baseContext
        self.content = base.content
        self.activePath = activePath
        self.header = header
        self.scripts = scripts
        self.modals = modals
        self.scrollSpy = scrollSpy
    }

    var body: HTML {
        BaseTemplate(context: baseContext) {
            Div {
                Div {
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
        .scrollSpy(scrollSpy)
    }

    func active(path: TemplateValue<String>) -> ContentBaseTemplate {
        ContentBaseTemplate(base: self, activePath: path, header: header, scripts: scripts, modals: modals, scrollSpy: scrollSpy)
    }

    func header(@HTMLBuilder _ header: () -> HTML) -> ContentBaseTemplate {
        ContentBaseTemplate(base: self, activePath: activePath, header: header(), scripts: scripts, modals: modals, scrollSpy: scrollSpy)
    }

    func scripts(@HTMLBuilder _ scripts: () -> HTML) -> ContentBaseTemplate {
        ContentBaseTemplate(base: self, activePath: activePath, header: header, scripts: scripts(), modals: modals, scrollSpy: scrollSpy)
    }

    func modals(@HTMLBuilder _ modals: () -> HTML) -> ContentBaseTemplate {
        ContentBaseTemplate(base: self, activePath: activePath, header: header, scripts: scripts, modals: modals(), scrollSpy: scrollSpy)
    }

    func scrollSpy(targetID: String, offset: Int = 0) -> ContentBaseTemplate {
        ContentBaseTemplate(base: self, activePath: activePath, header: header, scripts: scripts, modals: modals, scrollSpy: ScrollSpy(targetID: targetID, offset: offset))
    }

    struct KognitaNavigationBar: HTMLComponent {

        let userContext: TemplateValue<User>
        let activePath: TemplateValue<String>

        private let tabs: [TabContent] = [
            .init(
                link: "/subjects",
                icon: .formatListBulleted,
                title: ViewWrapper(view: Strings.menuSubjectList.localized())
            ),
            .init(
                link: "/practice-sessions/history",
                icon: .history,
                title: ViewWrapper(view: Strings.menuPracticeHistory.localized())
            )
        ]

        private let creatorTab = TabContent(
            link: "/creator/dashboard",
            icon: .accountCircle,
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
                    ListItem {
                        Form {
                            Anchor { Strings.menuLogout.localized() }
                                .class("nav-link")
                                .href("#")
                                .on(click: "this.closest(\"form\").submit()")
                        }
                        .action("/logout")
                        .method(.post)
                    }
                }
                .button {
                    HyperHamburgerMenu()
                }
            }
            .navigationBar(style: .dark)
            .class("topnav-navbar")
        }

        func tab(with tab: TemplateValue<TabContent>) -> HTML {
            ListItem {
                Anchor {
                    Span {
                        MaterialDesignIcon(tab.icon)
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
