//
//  StarterPage.swift
//  App
//
//  Created by Mats Mollestad on 26/02/2019.
//
// swiftlint:disable line_length nesting

import BootstrapKit

//extension ContextualTemplate {
//
//    var header: HTML.ContentNode<Self> { return .init(name: "header") }
//}

extension AttributeNode {
    func offset(width: ColumnWidth, for sizeClass: SizeClass) -> Self {
        switch sizeClass {
        case .all:  return self.class("offset-\(width.rawValue)")
        default:    return self.class("offset-\(sizeClass.rawValue)-\(width.rawValue)")
        }
    }
}

struct MaterialDesignIcon: HTMLComponent, AttributeNode {
    enum Icons: String {
        case infinity
    }

    let icon: TemplateValue<Icons>
    var attributes: [HTMLAttribute]

    init(icon: Icons) {
        self.icon = .constant(icon)
        self.attributes = []
    }

    init(icon: TemplateValue<Icons>) {
        self.icon = icon
        self.attributes = []
    }

    private init(icon: TemplateValue<Icons>, attributes: [HTMLAttribute]) {
        self.icon = icon
        self.attributes = attributes
    }

    func copy(with attributes: [HTMLAttribute]) -> MaterialDesignIcon {
        .init(icon: icon, attributes: attributes)
    }

    var body: HTML {
        Italic().class("mdi mdi-" + icon.rawValue)
    }
}

public struct Pages {}

extension Pages {
    public struct Landing: HTMLPage {

        private let info: [FeatureView.Info] = [
            .init(icon: "hourglass-start", title: "Vær effektiv", description: "Bruk mindre tid på å øve ved effektive læringsteknikker"),
            .init(icon: "trophy", title: "Motiverende", description: "Se en tydelig progresjon"),
            .init(icon: "star-o", title: "Kvalitet", description: "Innholdet er laget av fagpersjoner for å få høy kvalitet"),
            .init(icon: "heart-o", title: "Laget med av studenter for studenter", description: "Kognita er laget for at studenter skal den beste opplevelsen")
        ]

        public init() {}

        public var body: HTML {
            BaseTemplate(context: .init(
                    title: "Kognita",
                    description: "Kognita"
            )) {
                Div {
                    Container {
                        NavigationBar {
                            NavigationBar.Brand(link: "/") {
                                Span {
                                    LogoImage()
                                }.class("logo-lg")
                                Span {
                                    LogoImage()
                                }.class("logo-sm")
                            }
                            .class("logo")

                            NavigationBar.Collapse {
                                ListItem {
                                    Anchor {
                                        Span {
                                            Text(Strings.registerTitle)
                                        }
                                    }
                                    .href("/register")
                                    .class("nav-link")
                                }
                                .class("nav-item")
                                ListItem {
                                    Anchor {
                                        Span {
                                            Text(Strings.loginTitle)
                                        }
                                    }
                                    .href("/login")
                                    .class("nav-link")
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
                }
                .class("topnav")

                Section {
                    Container {
                        Row {
                            Div {
                                Text(Strings.starterPageDescription)
                                    .class("hero-title")
                                    .text(color: .white)
                                    .style(.heading2)
                                    .font(style: .regular)
                                Anchor(Strings.starterPageMoreButton)
                                    .href("/signup")
                                    .class("rounded-pill")
                                    .button(style: .success)
                                    .button(size: .extraLarge)
                                    .margin(.five, for: .top)
                            }
                            .column(width: .five, for: .medium)
                            .margin(.four, for: .top, sizeClass: .medium)
                            Div {
                                Div {
                                    Img(source: "/assets/images/startup.svg")
                                        .class("img-fluid")
                                }
                                .text(alignment: .right)
                                .margin(.three, for: .top)
                                .margin(.zero, for: .top, sizeClass: .medium)
                            }
                            .column(width: .five, for: .medium)
                            .offset(width: .two, for: .medium)
                        }
                    }
                }
                .class("hero-section")

                Section {
                    Container {
                        Row {
                            Div {
                                Div {
                                    Text {
                                        MaterialDesignIcon(icon: .infinity)
                                    }
                                    .style(.heading1)
                                    Text {
                                        "En liten tekst her"
                                    }
                                    .style(.heading3)
                                    Text {
                                        "En litt mindre tekst her?"
                                    }
                                }
                                .text(alignment: .center)
                            }
                            .column(width: .twelve, for: .large)
                        }
                        .padding(.four, for: .vertical)

                        Row {
                            Div {
                                Div {
                                    Div {
                                        Span {
                                            MaterialDesignIcon(icon: .infinity)
                                                .text(color: .primary)
                                        }
                                        .class("avatar-title bg-primary-lighten rounded-circle")
                                    }
                                    .class("avatar-sm")
                                    .margin(.auto)
                                    Text {
                                        "Feature beskrivelse"
                                    }
                                    .style(.heading4)
                                    .margin(.three, for: .top)
                                    Text {
                                        "En lengre beskrivles"
                                    }
                                    .text(color: .muted)
                                    .margin(.two, for: .top)
                                    .margin(.zero, for: .bottom)
                                }
                                .text(alignment: .center)
                                .padding(.three)
                            }
                            .column(width: .four, for: .large)
                            Div {
                                Div {
                                    Div {
                                        Span {
                                            MaterialDesignIcon(icon: .infinity)
                                                .text(color: .primary)
                                        }
                                        .class("avatar-title bg-primary-lighten rounded-circle")
                                    }
                                    .class("avatar-sm")
                                    .margin(.auto)
                                    Text {
                                        "Feature beskrivelse"
                                    }
                                    .style(.heading4)
                                    .margin(.three, for: .top)
                                    Text {
                                        "En lengre beskrivles"
                                    }
                                    .text(color: .muted)
                                    .margin(.two, for: .top)
                                    .margin(.zero, for: .bottom)
                                }
                                .text(alignment: .center)
                                .padding(.three)
                            }
                            .column(width: .four, for: .large)
                            Div {
                                Div {
                                    Div {
                                        Span {
                                            MaterialDesignIcon(icon: .infinity)
                                                .text(color: .primary)
                                        }
                                        .class("avatar-title bg-primary-lighten rounded-circle")
                                    }
                                    .class("avatar-sm")
                                    .margin(.auto)
                                    Text {
                                        "Feature beskrivelse"
                                    }
                                    .style(.heading4)
                                    .margin(.three, for: .top)
                                    Text {
                                        "En lengre beskrivles"
                                    }
                                    .text(color: .muted)
                                    .margin(.two, for: .top)
                                    .margin(.zero, for: .bottom)
                                }
                                .text(alignment: .center)
                                .padding(.three)
                            }
                            .column(width: .four, for: .large)
                        }
                        Row {
                            Div {
                                Div {
                                    Div {
                                        Span {
                                            MaterialDesignIcon(icon: .infinity)
                                                .text(color: .primary)
                                        }
                                        .class("avatar-title bg-primary-lighten rounded-circle")
                                    }
                                    .class("avatar-sm")
                                    .margin(.auto)
                                    Text {
                                        "Feature beskrivelse"
                                    }
                                    .style(.heading4)
                                    .margin(.three, for: .top)
                                    Text {
                                        "En lengre beskrivles"
                                    }
                                    .text(color: .muted)
                                    .margin(.two, for: .top)
                                    .margin(.zero, for: .bottom)
                                }
                                .text(alignment: .center)
                                .padding(.three)
                            }
                            .column(width: .four, for: .large)
                            Div {
                                Div {
                                    Div {
                                        Span {
                                            MaterialDesignIcon(icon: .infinity)
                                                .text(color: .primary)
                                        }
                                        .class("avatar-title bg-primary-lighten rounded-circle")
                                    }
                                    .class("avatar-sm")
                                    .margin(.auto)
                                    Text {
                                        "Feature beskrivelse"
                                    }
                                    .style(.heading4)
                                    .margin(.three, for: .top)
                                    Text {
                                        "En lengre beskrivles"
                                    }
                                    .text(color: .muted)
                                    .margin(.two, for: .top)
                                    .margin(.zero, for: .bottom)
                                }
                                .text(alignment: .center)
                                .padding(.three)
                            }
                            .column(width: .four, for: .large)
                            Div {
                                Div {
                                    Div {
                                        Span {
                                            MaterialDesignIcon(icon: .infinity)
                                                .text(color: .primary)
                                        }
                                        .class("avatar-title bg-primary-lighten rounded-circle")
                                    }
                                    .class("avatar-sm")
                                    .margin(.auto)
                                    Text {
                                        "Feature beskrivelse"
                                    }
                                    .style(.heading4)
                                    .margin(.three, for: .top)
                                    Text {
                                        "En lengre beskrivles"
                                    }
                                    .text(color: .muted)
                                    .margin(.two, for: .top)
                                    .margin(.zero, for: .bottom)
                                }
                                .text(alignment: .center)
                                .padding(.three)
                            }
                            .column(width: .four, for: .large)
                        }
                    }
                }
                .padding(.five, for: .vertical)

                KognitaFooter(isDark: false)
            }
            .header {
                Link().href("/assets/css/landing-page.css").relationship(.stylesheet).type("text/css")
                Link().href("/assets/fonts/font-awesome.min.css").relationship(.stylesheet).type("text/css")
            }
        }
    }

    struct FeatureView: HTMLComponent {

        struct Info {
            let icon: String
            let title: String
            let description: String
        }

        let info: TemplateValue<Info>

        var body: HTML {
            Div {
                Div {
                    Italic()
                        .class("fa fa-" + info.icon + " fa-4x sr-icons")
                        .margin(.three, for: .bottom)
                    Text {
                        info.title
                    }
                    .style(.heading3)
                    .margin(.three, for: .bottom)

                    Text {
                        info.description
                    }
                    .style(.paragraph)
                    .margin(.zero, for: .bottom)
                    .text(color: .light)
                }
                .class("service-box")
                .margin(.auto, for: .horizontal)
                .margin(.five, for: .top)
            }
            .text(alignment: .center)
            .column(width: .six, for: .medium)
            .column(width: .three, for: .large)
        }
    }
}


struct KognitaFooter: HTMLComponent, AttributeNode {

    let isDark: Conditionable
    var attributes: [HTMLAttribute]

    init(isDark: Conditionable = false) {
        self.isDark = isDark
        self.attributes = []
    }

    private init(isDark: Conditionable, attributes: [HTMLAttribute]) {
        self.isDark = isDark
        self.attributes = attributes
    }

    var body: HTML {
        Footer {
            Container {
                Row {
                    Div {
                        LogoImage(isDark: isDark)
                        Text {
                            "Kognita gjør det lettere å lære nytt pensum"
                            Break()
                            "Du kan derfor bruke mer tid på det du verdsetter"
                        }
                        .margin(.four, for: .top)
                        .text(color: .muted)
                    }
                    .column(width: .six, for: .large)
                    Div {
                        Text {
                            "Firma"
                        }
                        .style(.heading5)
                        .modify(if: isDark) {
                            $0.text(color: .white)
                        }
                        .modify(if: !isDark) {
                            $0.text(color: .dark)
                        }


                        UnorderedList {
                            ForEach(in: itemLinks) { item in
                                ListItemLink(context: item)
                            }
                        }
                        .class("list-unstyled")
                        .padding(.zero, for: .left)
                        .margin(.zero, for: .bottom)
                        .margin(.three, for: .top)
                    }
                    .column(width: .three, for: .large)
                    .offset(width: .three, for: .large)
                }
                Row {
                    Div {
                        Div {
                            Text(Strings.copyright)
                                .text(color: .muted)
                                .text(alignment: .center)
                                .margin(.four, for: .top)
                        }
                        .margin(.five, for: .top)
                    }
                    .column(width: .twelve, for: .large)
                }
            }
        }
        .padding(.five, for: .vertical)
        .class("border-top border-light")
        .modify(if: isDark) {
            $0.background(color: .dark)
        }
        .modify(if: !isDark) {
            $0.background(color: .white)
        }
        .add(attributes: attributes)
    }

    func copy(with attributes: [HTMLAttribute]) -> KognitaFooter {
        .init(isDark: isDark, attributes: attributes)
    }

    let itemLinks: [ListItemLink.Context] = [
        .init(title: "Om oss", url: "#"),
        .init(title: "Brukervilkår", url: "/terms-of-usage"),
        .init(title: "Personværn", url: "/privacy-policy"),
    ]

    struct ListItemLink: HTMLComponent {

        struct Context {
            let title: String
            let url: String
        }

        let context: TemplateValue<Context>

        var body: HTML {
            ListItem {
                Anchor {
                    context.title
                }
                .href(context.url)
                .text(color: .muted)
            }
            .margin(.two, for: .top)
        }
    }
}
