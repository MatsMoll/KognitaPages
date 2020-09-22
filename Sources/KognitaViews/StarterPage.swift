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
                title: "Flerbruk",
                description: "Gjør notatene dine til et kompendie, samtidig det blir til oppgaver å øve på"
            ),
            .init(
                icon: .emoticonExcited,
                title: "Finn roen",
                description: "Få en oversikt over hva du kan, og finn roen før eksamen"
            ),
            .init(
                icon: .trophyOutline,
                title: "Motiverende",
                description: "Øk motivasjonen med å se progrisjon over tid"
            )
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
                                Text { "Få bedre kontroll på pensum" }
                                    .class("hero-title")
                                    .text(color: .white)
                                    .style(.heading1)
                                    .font(style: .regular)

                                Text { "Få mer ut av notatene dine og bruk mindre tid på pensum ved å bruke effektive læringsteknikker som er vitenskapelig bevist. I tillegg er Kognita designet for å gjøre øvingen mer motiverende ved å gjøre opplevelsen mer spill-aktig." }
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
                                    Text { "Hva tilbyr Kognita?" }
                                        .style(.heading2)
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

                Section {
                    Container {
                        Row {
                            Div {
                                Div {
                                    Text { "Hva sier brukerene våre?" }
                                        .style(.heading2)
                                }
                                .text(alignment: .center)
                            }
                            .column(width: .twelve, for: .large)

                        }
                        .padding(.four, for: .vertical)

                        Row {
                            Div {
                                Div {
                                    Span {
                                        MaterialDesignIcon(.check)
                                            .text(color: .primary)
                                    }
                                    .class("avatar-title rounded-circle")
                                    .background(color: .light)
                                }
                                .class("avatar-xs")
                                .float(.left)

                                Text { "Kognita har hjulpet meg med å stå obligatoriske prøver gjennom semesteret, slik at jeg kunne gå opp til eksamen" }
                                    .margin(.four, for: .left)
                                    .style(.lead)
                            }
                            .column(width: .five, for: .large)
                            .offset(width: .one, for: .large)

                            Div {
                                Div {
                                    Span {
                                        MaterialDesignIcon(.check)
                                            .text(color: .primary)
                                    }
                                    .class("avatar-title rounded-circle")
                                    .background(color: .light)
                                }
                                .class("avatar-xs")
                                .float(.left)

                                Text { "Ved å tilby rask tilbakemelding sammen med høy informasjonstetthet, har Kognita vært et godt hjelpemiddel gjennom semesteret" }
                                    .margin(.four, for: .left)
                                    .style(.lead)
                            }
                            .column(width: .five, for: .large)
                        }
                    }
                }
                .padding(.five, for: .vertical)
                .background(color: .white)
                .class("border-top border-light")

                Section {
                    Container {
                        Row {
                            Div {
                                Div {
                                    Text { "Kontakt oss" }
                                        .style(.heading2)
                                }
                                .text(alignment: .center)
                            }
                            .column(width: .twelve, for: .large)

                        }
                        .padding(.four, for: .vertical)

                        Row {
                            Div {
                                Text { "E-post addresse" }.font(style: .bold)
                                Text { "kontakt@kognita.no" }
                            }
                            .column(width: .four, for: .medium)

                            Div {
                                Form {
                                    FormGroup(label: "Tema") {
                                        Input()
                                            .type(.text)
                                            .id("subject")
                                            .placeholder("Skriv hva det handler om har")
                                            .class("form-control-light")
                                    }

                                    FormGroup(label: "Melding") {
                                        TextArea()
                                            .id("body")
                                            .placeholder("Skriv din melding her")
                                            .class("form-control-light")
                                    }

                                    Button {
                                        "Send e-post"
                                        MaterialDesignIcon(.email)
                                            .margin(.one, for: .left)
                                    }
                                    .button(style: .info)
                                    .type(.submit)
                                }
                                .action("mailto:kontakt@kognita.no")
                                .method(.get)
                                .encodeType(.plain)
                            }
                            .column(width: .eight, for: .medium)
                        }
                    }
                }
                .padding(.five, for: .vertical)
                .class("border-top border-light")

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
