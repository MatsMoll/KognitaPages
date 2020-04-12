//
//  StarterPage.swift
//  App
//
//  Created by Mats Mollestad on 26/02/2019.
//
// swiftlint:disable line_length nesting

import BootstrapKit

extension AttributeNode {
    func offset(width: ColumnWidth, for sizeClass: SizeClass) -> Self {
        switch sizeClass {
        case .all:  return self.class("offset-\(width.rawValue)")
        default:    return self.class("offset-\(sizeClass.rawValue)-\(width.rawValue)")
        }
    }
}


public struct Pages {}

extension Pages {
    public struct Landing: HTMLPage {

        private let info: [FeatureView.Info] = [
            .init(
                icon: .teach,
                title: "Aktiv læring",
                description: "Bruk metoder som er vitenskapelig bevist"
            ),
            .init(
                icon: .emoticonExcited,
                title: "Motiverende",
                description: "Få en spillifisert brukeropplevelse som er mer motiverende"
            ),
            .init(
                icon: .trophyOutline,
                title: "Relevant innhold",
                description: "Gjør eksamensoppgaver og innhold som er godkjent av faglærere"
            ),
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
                                HyperHamburgerMenu()
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
                                Text { "Bruk mindre tid på pensum" }
                                    .class("hero-title")
                                    .text(color: .white)
                                    .style(.heading2)
                                    .font(style: .regular)

                                Text { "Kognita baserer seg på effektive læringsteknikker som er vitenskapelig bevist. I tillegg er Kognita designet for å gjøre øvingen mer motiverende ved å gjøre opplevelsen mer spill-aktig." }
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
                                    Text { MaterialDesignIcon(.starOutline) }
                                        .style(.heading1)

                                    Text { "Some text with an icon" }
                                        .style(.heading3)
                                }
                                .text(alignment: .center)
                            }
                            .column(width: .twelve, for: .large)

                        }
                        .padding(.four, for: .vertical)

                        Row {
                            ForEach(in: info) { info in
                                Div {
                                    FeatureView(info: info)
                                }
                                .column(width: .four, for: .large)
                            }
                        }
                    }
                }
                .padding(.five, for: .vertical)

                KognitaFooter(isDark: false)
            }
            .header {
                Stylesheet(url: "/assets/css/landing-page.css")
                Stylesheet(url: "/assets/fonts/font-awesome.min.css")
            }
        }
    }

    struct FeatureView: HTMLComponent {

        struct Info {
            let icon: MaterialDesignIcon.Icons
            let title: String
            let description: String
        }

        let info: TemplateValue<Info>

        var body: HTML {
            Div {
                Div {
                    Span {
                        MaterialDesignIcon(info.icon)
                            .text(color: .primary)
                    }
                    .class("avatar-title bg-primary-lighten rounded-circle")
                }
                .class("avatar-sm")
                .margin(.auto)
                Text {
                    info.title
                }
                .style(.heading4)
                .margin(.three, for: .top)
                Text {
                    info.description
                }
                .text(color: .muted)
                .margin(.two, for: .top)
                .margin(.zero, for: .bottom)
            }
            .text(alignment: .center)
            .padding(.three)
        }
    }
}
