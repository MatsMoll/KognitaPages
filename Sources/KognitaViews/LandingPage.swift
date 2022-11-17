//
//  StarterPage.swift
//  App
//
//  Created by Mats Mollestad on 26/02/2019.
//
// swiftlint:disable line_length nesting

import Foundation
import BootstrapKit

extension AttributeNode {
    func offset(width: ColumnWidth, for sizeClass: SizeClass) -> Self {
        switch sizeClass {
        case .all:  return self.class("offset-\(width.rawValue)")
        default:    return self.class("offset-\(sizeClass.rawValue)-\(width.rawValue)")
        }
    }
}

/// A Structure to group different pages
public struct Pages {}

extension Pages {

    /// A page giving an overview for the users landing on the website
    public struct Landing: HTMLTemplate {

        private let info: [FeatureView.Info] = [
            .init(
                icon: .emoticonExcited,
                title: "Finn roen",
                description: "Få en oversikt over hva du kan, og finn roen før eksamen"
            ),
            .init(
                icon: .trophyOutline,
                title: "Motiverende",
                description: "Øk motivasjonen med å se progresjon over tid"
            ),
            .init(
                icon: .teach,
                title: "Flerbruk",
                description: "Få mer ut av notatene dine og gjør dem til oppgaver samtidig som du får et kompendium"
            )
        ]

        public struct Context {
            let showCookieMessage: Bool
            let numberOfCompletedTasks: Int
            let numberOfUsers: Int
            let formatter: NumberFormatter
            
            var formattedNumberOfCompletedTasks: String {
                return formatter.string(from: .init(integerLiteral: numberOfCompletedTasks)) ?? "\(numberOfCompletedTasks)"
            }
            
            var formattedNumberOfUsers: String {
                return formatter.string(from: .init(integerLiteral: numberOfUsers)) ?? "\(numberOfUsers)"
            }

            var baseContext: BaseTemplateContent {
                .init(title: "Kognita", description: "Kognita", showCookieMessage: showCookieMessage)
            }

            public init(showCookieMessage: Bool, numberOfCompletedTasks: Int, numberOfUsers: Int) {
                self.showCookieMessage = showCookieMessage
                self.numberOfCompletedTasks = numberOfCompletedTasks
                self.numberOfUsers = numberOfUsers
                self.formatter = NumberFormatter()
                formatter.numberStyle = .decimal
            }
        }

        public init() {}

        public var body: HTML {
            BaseTemplate(context: context.baseContext) {
                Div {
                    Container {
                        NavigationBar {
                            NavigationBar.Brand(link: Paths.landingPage) {
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
                                        Span { Text(Strings.menuSubjectList) }
                                    }
                                    .href(Paths.subjects)
                                    .class("nav-link")
                                }
                                .class("nav-item")
                                ListItem {
                                    Anchor {
                                        Span { Text(Strings.menuRegister) }
                                    }
                                    .href(Paths.signup)
                                    .class("nav-link")
                                }
                                .class("nav-item")
                                ListItem {
                                    Anchor {
                                        Span { Text(Strings.loginTitle) }
                                    }
                                    .href(Paths.login)
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
                                Text { "Få kontroll på pensum" }
                                    .class("hero-title")
                                    .text(color: .white)
                                    .style(.heading1)
                                    .font(style: .regular)

                                Text { "Se hvordan du gjør det på tidligere ekamensoppgaver, og dekk dine kunnskapshull fortere. Kognita gjør det lettere å finne hull med å bruke AI i interaktive flash-cards, og flervalgsoppgaver." }
                                    .class("text-white-50")
                                
                                Row {
                                    Div {
                                        SingleStatisticCard(
                                            title: "Antall oppgaver gjort 🚀", mainContent: context.formattedNumberOfCompletedTasks, moreDetails: .constant(nil)
                                        ).margin(.four, for: .top)
                                    }
                                    .column(width: .six, for: .small)
                                    
                                    Div {
                                        SingleStatisticCard(
                                            title: "Antall bruker 👨‍👩‍👧‍👦", mainContent: context.formattedNumberOfUsers, moreDetails: .constant(nil)
                                        ).margin(.four, for: .top)
                                    }
                                    .column(width: .six, for: .small)
                                }
                                
                                Div {
                                    Anchor(Strings.menuSubjectList)
                                        .href(Paths.subjects)
                                        .class("rounded-pill")
                                        .button(style: .light)
                                        .margin(.two, for: .right)

                                }
                                .margin(.five, for: .top)

                            }
                            .column(width: .five, for: .medium)
                            .margin(.four, for: .top, sizeClass: .medium)
                            Div {
                                Div {
                                    Img(source: "/assets/images/ios/MultipleChoice.png")
                                        .style(css: "max-width: 100%; max-height: 650px")
                                }
                                .text(alignment: .left)
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
                                    Text { "Hvordan fungerer Kognita?" }
                                        .style(.heading2)
                                }
                                .text(alignment: .center)
                            }
                            .column(width: .twelve, for: .large)

                        }
                        .padding(.four, for: .vertical)

                        Row {
                            Div {
                                Img(source: "/assets/images/ios/MultipleChoice.png").style(css: "max-width: 100%;")
                                Text {
                                    "Flervalgsoppgaver med rask tilbakemelding"
                                }
                                .text(alignment: .center)
                            }
                            .column(width: .four, for: .medium)
                            Div {
                                Img(source: "/assets/images/ios/Goal.png").style(css: "max-width: 100%;")
                                Text {
                                    "Sett øvingsmål og stop når det er nok"
                                }
                                .text(alignment: .center)
                            }
                            .column(width: .four, for: .medium)
                            Div {
                                Img(source: "/assets/images/ios/Results.png").style(css: "max-width: 100%;")
                                Text {
                                    "Få en tydelig oversikt over pensum"
                                }
                                .text(alignment: .center)
                            }
                            .column(width: .four, for: .medium)
                        }
                        
                        Row {
                            Anchor(Strings.menuSubjectList)
                                .href(Paths.subjects)
                                .class("rounded-pill")
                                .button(style: .primary)
                                .margin(.auto)
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
