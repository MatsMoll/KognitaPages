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
        case check
        case checkAll = "check-all"
        case minus
        case eye
        case close
        case save
        case delete
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
            .init(icon: "star-o", title: "Kvalitet", description: "Innholdet er laget av fagpersoner med god kompetanse"),
            .init(icon: "heart-o", title: "Laget med, av og for studenter", description: "Kognita er laget for å gi studenter den beste læringsopplevelsen")
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
                                            Text(Strings.menuRegister)
                                        }
                                    }
                                    .href("/signup")
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
                                Text {
                                    "Bruk mindre tid på pensum"
                                }
                                    .class("hero-title")
                                    .text(color: .white)
                                    .style(.heading2)
                                    .font(style: .regular)
                                Text {
                                    "Kognita baserer seg på effektive læringsteknikker som er vitenskapelig bevist. I tillegg er Kognita designet for å gjøre øvingen mer motiverende ved å gjøre opplevelsen mer spill-aktig."
                                }
                                .class("text-white-50")
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
