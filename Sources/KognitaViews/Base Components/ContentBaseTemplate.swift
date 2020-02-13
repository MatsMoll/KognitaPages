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

    private init(base: ContentBaseTemplate, activePath: TemplateValue<String>, header: HTML, scripts: HTML, modals: HTML) {
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
            .init(
                link: "/subjects",
                icon: .formatListBulleted,
                title: ViewWrapper(view: Strings.menuSubjectList.localized())
            ),
            .init(
                link: "/practice-sessions/history",
                icon: .history,
                title: ViewWrapper(view: Strings.menuPracticeHistory.localized())
            ),
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
                        Anchor{
                            Text {
                                MaterialDesignIcon(.accountCircle)
                                " "
                                userContext.username
                            }
                            .style(.cardText)
                        }
                        .class("nav-link dropdown")
                        .id("navbarDropdown")
                        .role("button")

                        Div {
                            Form {
                                Anchor {
                                    "Min profil"
                                }
                                .href("/profile")
                                .class("dropdown-item")


                                Anchor {
                                    Strings.menuLogout.localized()
                                }
                                .class("dropdown-item")
                                .href("#")
                                .on(click: "this.closest(\"form\").submit()")
                            }
                            .action("/logout")
                            .method(.post)
                        }
                        .class("dropdown-menu")
                        .margin(.zero)
                    }
                    .class("nav-item dropdown")
                }
                .button {
                    HyperHamburgerMenu()
                }
            }
            .navigationBar(style: .dark)
            .class("topnav-navbar")


            //            NavigationBar.Collapse {
            //                    ForEach(in: tabs) { tab in
            //                        self.tab(with: tab)
            //                    }
            //                    ListItem {
            //                        Form {
            //                            NavigationBar {
            //                                Strings.menuLogout.localized()
            //                            }
            //                            .background(color: .primary)
            //                            .class("nav-link btn")
            //                        }
            //                        //.method(.post)
            //                        .action("/logout")
            //                        .background(color: .primary)
            //                    }
            //                    .class("nav-item")
            //                }
            //                .button {
            //                    HyperHamburgerMenu()
            //                }
            //            }
            //            .navigationBar(style: .dark)
            //            .class("topnav-navbar")
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

