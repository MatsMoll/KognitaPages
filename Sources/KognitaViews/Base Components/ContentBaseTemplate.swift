import BootstrapKit

struct ContentBaseTemplateContent {
    let base: BaseTemplateContent
    let user: User

    init(user: User, title: String, description: String = "", showCookieMessage: Bool) {
        self.base = .init(title: title, description: description, showCookieMessage: showCookieMessage)
        self.user = user
    }
}

protocol ActivePathSelectable: HTML {
    func active(path: TemplateValue<String>) -> Self
}

struct ContentBaseTemplate: HTMLComponent {

    struct TabContent {
        let link: String
        let icon: MaterialDesignIcon.Icons
        let title: ViewWrapper
    }

    let baseContext: TemplateValue<BaseTemplateContent>
    let scrollSpy: ScrollSpy?

    let navigationBar: ActivePathSelectable
    let content: HTML
    let header: HTML
    let scripts: HTML
    let modals: HTML

    init(userContext: TemplateValue<User>, baseContext: TemplateValue<BaseTemplateContent>, @HTMLBuilder content: () -> HTML) {
        self.baseContext = baseContext
        self.content = content()
        self.header = ""
        self.scripts = ""
        self.modals = ""
        self.scrollSpy = nil
        self.navigationBar = KognitaNavigationBar(
            activePath: .constant(""),
            customTabs: KognitaNavigationBar.LogoutItem()
        )
    }
    
    init(baseContext: TemplateValue<BaseTemplateContent>, @HTMLBuilder content: () -> HTML) {
        self.baseContext = baseContext
        self.content = content()
        self.header = ""
        self.scripts = ""
        self.modals = ""
        self.scrollSpy = nil
        self.navigationBar = KognitaNavigationBar(activePath: .constant(""), logoPath: Paths.landingPage)
    }

    private init(base: ContentBaseTemplate, navigationBar: ActivePathSelectable, header: HTML, scripts: HTML, modals: HTML, scrollSpy: ScrollSpy?) {
        self.navigationBar = navigationBar
        self.baseContext = base.baseContext
        self.content = base.content
        self.header = header
        self.scripts = scripts
        self.modals = modals
        self.scrollSpy = scrollSpy
    }

    var body: HTML {
        BaseTemplate(context: baseContext) {
            Div {
                Div {
                    Container { navigationBar }
                }
                .class("topnav")

                Div {
                    Container { content }
                }
                .class("content")

                KognitaFooter()
                    .margin(.three, for: .top)
            }.class("wrapper")

            modals
        }
        .header { header }
        .scripts { scripts }
        .scrollSpy(scrollSpy)
    }

    func active(path: TemplateValue<String>) -> ContentBaseTemplate {
        ContentBaseTemplate(base: self, navigationBar: navigationBar.active(path: path), header: header, scripts: scripts, modals: modals, scrollSpy: scrollSpy)
    }

    func header(@HTMLBuilder _ header: () -> HTML) -> ContentBaseTemplate {
        ContentBaseTemplate(base: self, navigationBar: navigationBar, header: header(), scripts: scripts, modals: modals, scrollSpy: scrollSpy)
    }

    func scripts(@HTMLBuilder _ scripts: () -> HTML) -> ContentBaseTemplate {
        ContentBaseTemplate(base: self, navigationBar: navigationBar, header: header, scripts: scripts(), modals: modals, scrollSpy: scrollSpy)
    }

    func modals(@HTMLBuilder _ modals: () -> HTML) -> ContentBaseTemplate {
        ContentBaseTemplate(base: self, navigationBar: navigationBar, header: header, scripts: scripts, modals: modals(), scrollSpy: scrollSpy)
    }

    func scrollSpy(targetID: String, offset: Int = 0) -> ContentBaseTemplate {
        ContentBaseTemplate(base: self, navigationBar: navigationBar, header: header, scripts: scripts, modals: modals, scrollSpy: ScrollSpy(targetID: targetID, offset: offset))
    }

    struct KognitaNavigationBar: HTMLComponent, ActivePathSelectable {

        let activePath: TemplateValue<String>
        var customTabs: HTML = ""
        var logoPath: String = Paths.subjects

        private let tabs: [TabContent] = [
            .init(
                link: Paths.subjects,
                icon: .formatListBulleted,
                title: ViewWrapper(view: Strings.menuSubjectList.localized())
            ),
            .init(
                link: Paths.history,
                icon: .history,
                title: ViewWrapper(view: Strings.menuPracticeHistory.localized())
            )
        ]
        
        func active(path: TemplateValue<String>) -> Self {
            Self(activePath: path, customTabs: customTabs, logoPath: logoPath)
        }

        var body: HTML {
            NavigationBar {
                NavigationBar.Brand(link: logoPath) {
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
                    customTabs
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
        
        struct LogoutItem: HTMLComponent {
            var body: HTML {
                ListItem {
                    Form {
                        Anchor { Strings.menuLogout.localized() }
                            .class("nav-link")
                            .href("#")
                            .on(click: "this.closest(\"form\").submit()")
                    }
                    .action(Paths.logout)
                    .method(.post)
                }
            }
        }
    }
}
