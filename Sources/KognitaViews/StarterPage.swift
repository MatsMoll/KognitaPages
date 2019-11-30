////
////  StarterPage.swift
////  App
////
////  Created by Mats Mollestad on 26/02/2019.
////
//// swiftlint:disable line_length nesting
//
//import BootstrapKit
//
////extension ContextualTemplate {
////
////    var header: HTML.ContentNode<Self> { return .init(name: "header") }
////}
//
//public struct Pages {}
//
//extension Pages {
//    public struct Landing: HTMLPage {
//
//        public init() {}
//
//        public var body: HTML {
//            BaseTemplate(context: .init(
//                    title: "Kognita",
//                    description: "Kognita"
//            )) {
//                Nav {
//                    Container {
//                        Anchor {
//                            Span {
//                                Img()
//                                    .source("/assets/images/logo.png")
//                                    .alt("")
//                                    .height(30)
//                            }
//                            .class("logo-lg")
//                            Span {
//                                Img()
//                                    .source("/assets/images/logo_sm.png")
//                                    .alt("")
//                                    .height(30)
//                            }
//                            .class("logo-sm")
//                        }
//                        .href("/")
//                        .class("logo")
//                        .text(alignment: .center)
//                        Div {
//                            UnorderdList {
//                                ListItem {
//                                    Anchor(Strings.menuRegister)
//                                        .class("nav-link")
//                                        .href("/signup")
//                                }
//                                .class("nav-item")
//                                ListItem {
//                                    Anchor(Strings.menuLogin)
//                                        .class("nav-link")
//                                        .href("/login")
//                                }
//                                .class("nav-item")
//                            }
//                            .class("navbar-nav")
//                            .margin(.auto, for: .left)
//                        }
//                        .class("collapse navbar-collapse")
//                        .id("navbarResponsive")
//                    }
//                }
//                .class("navbar navbar-expand-lg navbar-dark navbar-custom fixed-top")
//                Header {
//                    Div {
//                        Container {
//                            Text(Strings.starterPageDescription)
//                                .class("masthead-heading")
//                                .margin(.zero, for: .bottom)
//                                .style(.heading1)
//
//                            Anchor(Strings.starterPageMoreButton)
//                                .href("/signup")
//                                .class("rounded-pill")
//                                .button(style: .primary)
//                                .button(size: .extraLarge)
//                                .margin(.five, for: .top)
//                        }
//                    }
//                    .class("masthead-content")
//                }
//                .class("masthead")
//                .text(alignment: .center)
//                .text(color: .white)
//
//                Section {
//                    Container(mode: .fluid) {
//                        Row {
//                            Div {
//                                Text {
//                                    "Hvordan funkere det?"
//                                }
//                                .style(.display4)
//                                Text {
//                                    "Kognita baserer seg på effektive læringsteknikker som er vitenskapelig bevist. I tillegg er Kognita designet for å gjøre øvingen mer motiverende ved å gjøre øvingen mer spill aktig."
//                                }
//                                .style(.paragraph)
//                                .margin(.two, for: .top)
//                            }
//                            .margin(.auto)
//                            .padding(.five)
//                            .column(width: .eight)
//                            .text(alignment: .center)
//                        }
//                        .alignment(.itemsCenter)
//                    }
//                }
//                Section {
//                    Container(mode: .fluid) {
//                        Row {
//                            Div {
//                                Text {
//                                    "Vår tjeneste"
//                                }
//                                .style(.display4)
//                            }
//                            .column(width: .twelve)
//                            .text(alignment: .center)
//
//                            FeatureView(
//                                icon: "hourglass-start",
//                                title: "Vær effektiv",
//                                description: "Bruk mindre tid på å øve ved effektive læringsteknikker"
//                            )
//                            FeatureView(
//                                icon: "trophy",
//                                title: "Motiverende",
//                                description: "Se en tydelig progresjon"
//                            )
//                            FeatureView(
//                                icon: "star-o",
//                                title: "Kvalitet",
//                                description: "Innholdet er laget av fagpersjoner for å få høy kvalitet"
//                            )
//                            FeatureView(
//                                icon: "heart-o",
//                                title: "Laget med kjærlighet",
//                                description: "Kognita er laget for at studenter skal den beste opplevelsen"
//                            )
//                        }
//                        .padding(.five, for: .top)
//                        .padding(.five, for: .bottom)
//                    }
//                    .text(color: .white)
//                    .background(color: .primary)
//                    .margin(.five, for: .bottom)
//                }
//                Section {
//                    Container(mode: .fluid) {
//                        Row {
//                            Div {
//                                Text {
//                                    "Kontakt oss?"
//                                }
//                                .style(.display4)
//                                Div {
//                                    Italic()
//                                        .class("fa fa-envelope fa-4x sr-icons")
//                                        .margin(.three, for: .bottom)
//                                    Anchor {
//                                        Text { "kontakt@kognita.no" }
//                                            .style(.heading3)
//                                    }
//                                    .mail(to: "mats@kognita.no")
//                                }
//                                .class("service-box")
//                                .margin(.five, for: .top)
//                            }
//                            .text(alignment: .center)
//                            .margin(.auto, for: .horizontal)
//                            .column(width: .six, for: .medium)
//                            .column(width: .three, for: .large)
//                        }
//                    }
//                }
//                Footer{
//                    Container {
//                        Text(Strings.copyright)
//                            .class("small")
//                            .margin(.zero)
//                            .text(color: .white)
//                            .text(alignment: .center)
//                            .style(.paragraph)
//                    }
//                }
//                .padding(.five, for: .vertical)
//                .background(color: .dark)
//            }
//            .header {
//                Link().href("assets/css/landing-page.css").relationship(.stylesheet).type("text/css")
//                Link().href("assets/fonts/font-awesome.min.css").relationship(.stylesheet).type("text/css")
//            }
//        }
//    }
//
//    struct FeatureView: HTMLComponent {
//
//        let icon: RootValue<String>
//        let title: RootValue<String>
//        let description: RootValue<String>
//
//        var body: HTML {
//            Div {
//                Div {
//                    Italic()
//                        .class("fa fa-" + icon + " fa-4x sr-icons")
//                        .margin(.three, for: .bottom)
//                    Text {
//                        title
//                    }
//                    .style(.heading3)
//                    .margin(.three, for: .bottom)
//
//                    Text {
//                        description
//                    }
//                    .style(.paragraph)
//                    .margin(.zero, for: .bottom)
//                    .text(color: .light)
//                }
//                .class("service-box")
//                .margin(.auto, for: .horizontal)
//                .margin(.five, for: .top)
//            }
//            .text(alignment: .center)
//            .column(width: .six, for: .medium)
//            .column(width: .three, for: .large)
//        }
//    }
//}
