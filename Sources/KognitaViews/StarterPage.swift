//
//  StarterPage.swift
//  App
//
//  Created by Mats Mollestad on 26/02/2019.
//
// swiftlint:disable line_length nesting

import HTMLKit

extension ContextualTemplate {

    var header: HTML.ContentNode<Self> { return .init(name: "header") }
}


public struct StarterPage: LocalizedTemplate {

    public init() {}

    public static var localePath: KeyPath<StarterPage.Context, String>? = \.locale

    public enum LocalizationKeys: String {
        case registerMenu = "menu.register"
        case loginMenu = "menu.login"
        case starterPageTitle = "starter.page.title"
        case starterPageDescription = "starter.page.description"
        case starterPageMoreButton = "starter.page.more.button"
        case copyright = "footer.copyright"
    }

    public struct Context {
        let locale = "nb"
        let base: BaseTemplate.Context

        public init() {
            base = .init(title: "Start side", description: "Start side")
        }
    }

    let mainImageURL = "https://cognita.network/wp-content/themes/cognita/images/logo-cog.png"

    public func build() -> CompiledTemplate {
        return embed(
            BaseTemplate(
                body:
                nav.class("navbar navbar-expand-lg navbar-dark navbar-custom fixed-top").child(
                    div.class("container").child(
                        // Logo
                        a.href("/").class("logo text-center").child(
                            span.class("logo-lg").child(
                                img.src("/assets/images/logo.png").alt("").height(30)
                            ),
                            span.class("logo-sm").child(
                                img.src("/assets/images/logo_sm.png").alt("").height(30)
                            )
                        ),
                        div.class("collapse navbar-collapse").id("navbarResponsive").child(
                            ul.class("navbar-nav ml-auto").child(
                                li.class("nav-item").child(
                                    a.class("nav-link").href("/signup").child(
                                        localize(.registerMenu)
                                    )
                                ),
                                li.class("nav-item").child(
                                    a.class("nav-link").href("/login").child(
                                        localize(.loginMenu)
                                    )
                                )
                            )
                        )
                    )
                ),
                header.class("masthead text-center text-white").child(
                    div.class("masthead-content").child(
                        div.class("container").child(
                            h1.class("masthead-heading mb-0").child(
                                localize(.starterPageDescription)
                            ),
                            a.href("/signup").class("btn btn-primary btn-xl rounded-pill mt-5").child(
                                localize(.starterPageMoreButton)
                            )
                        )
                    )
                ),
                section.child(
                    div.class("container-fluid").child(
                        div.class("row align-items-center").child(
                            div.class("col-8 m-auto p-5 text-center").child(
                                h2.class("display-4").child(
                                    "Hvordan funkere det?"
                                ),
                                p.class("mt-2").child(
                                    "Kognita baserer seg på effektive læringsteknikker som er vitenskapelig bevist. I tillegg er Kognita designet for å gjøre øvingen mer motiverende ved å gjøre øvingen mer spill aktig."
                                )
                            )
                        )
                    )
                ),
                section.child(
                    div.class("container-fluid bg-primary text-white mb-5").child(
                        div.class("row pt-5 pb-5").child(
                            div.class("col-12 text-center").child(
                                h2.class("display-4").child(
                                    "Vår tjeneste"
                                )
                            ),
                            div.class("col-md-6 col-lg-3 text-center").child(
                                div.class("mx-auto service-box mt-5").child(
                                    i.class("fa fa-hourglass-start fa-4x mb-3 sr-icons"),
                                    h3.class("mb-3").child(
                                        "Vær effektiv"
                                    ),
                                    p.class("mb-0 text-light").child(
                                        "Bruk mindre tid på å øve ved effektive læringsteknikker"
                                    )
                                )
                            ),
                            div.class("col-md-6 col-lg-3 text-center").child(
                                div.class("mx-auto service-box mt-5").child(
                                    i.class("fa fa-trophy fa-4x mb-3 sr-icons"),
                                    h3.class("mb-3").child(
                                        "Motiverende"
                                    ),
                                    p.class("mb-0 text-light").child(
                                        "Se en tydelig progresjon"
                                    )
                                )
                            ),
                            div.class("col-md-6 col-lg-3 text-center").child(
                                div.class("mx-auto service-box mt-5").child(
                                    i.class("fa fa-star-o fa-4x mb-3 sr-icons"),
                                    h3.class("mb-3").child(
                                        "Kvalitet"
                                    ),
                                    p.class("mb-0 text-light").child(
                                        "Innholdet er laget av fagpersjoner for å få høy kvalitet"
                                    )
                                )
                            ),
                            div.class("col-md-6 col-lg-3 text-center").child(
                                div.class("mx-auto service-box mt-5").child(
                                    i.class("fa fa-heart-o fa-4x mb-3 sr-icons"),
                                    h3.class("mb-3").child(
                                        "Laget med kjærlighet"
                                    ),
                                    p.class("mb-0 text-light").child(
                                        "Kognita er laget for at studenter skal den beste opplevelsen"
                                    )
                                )
                            )
                        )
                    )
                ),
                section.child(
                    div.class("container-fluid").child(
                        div.class("row").child(
                            div.class("col-md-6 col-lg-3 text-center mx-auto").child(
                                h2.class("display-4").child(
                                    "Kontakt oss?"
                                ),
                                div.class("service-box mt-5").child(
                                    i.class("fa fa-envelope fa-4x mb-3 sr-icons"),
                                    a.class("text-").href("mailto:mats@kognita.no").child(
                                        h3.child(
                                            "kontakt@kognita.no"
                                        )
                                    )
                                )
                            )
                        )
                    )
                ),

                footer.child("py-5 bg-black").child(
                    div.class("container").child(
                        p.class("m-0 text-center text-white small").child(
                            localize(.copyright)
                        )
                    )
                ),
                customHeader: [
                    link.href("assets/css/landing-page.css").rel("stylesheet").type("text/css"),
                    link.href("assets/fonts/font-awesome.min.css").rel("stylesheet").type("text/css")
                ]
            ),
            withPath: \.base)
    }
}
