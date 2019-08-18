//
//  CreatorInformationPage.swift
//  App
//
//  Created by Mats Mollestad on 27/02/2019.
//
// swiftlint:disable line_length nesting

import HTMLKit
import KognitaCore

public struct CreatorInformationPage: LocalizedTemplate {

    public init() {}

    public static var localePath: KeyPath<CreatorInformationPage.Context, String>? = \.locale

    public enum LocalizationKeys: String {
        case none
    }

    public struct Context {
        let locale = "nb"
        let base: ContentBaseTemplate.Context

        public init(user: User) {
            base = .init(user: user, title: "Lag innhold")
        }
    }

    public func build() -> CompiledTemplate {
        return embed(
            ContentBaseTemplate(
                body:

                header.class("masthead text-center text-white").child(
                    div.class("masthead-content").child(
                        div.class("container").child(
                            h1.class("masthead-heading mb-0").child(
                                "One Page Wonder"
                            ),
                            h2.class("masthead-subheading mb-0").child(
                                "Will Rock Your Socks Off"
                            ),
                            a.href("dashboard").class("btn btn-primary btn-xl rounded-pill mt-5").child(
                                "Learn More"
                            )
                        )
                    ),
                    div.class("bg-circle-1 bg-circle"),
                    div.class("bg-circle-2 bg-circle"),
                    div.class("bg-circle-3 bg-circle"),
                    div.class("bg-circle-4 bg-circle")
                ),
                section.child(
                    div.class("container").child(
                        div.class("row align-items-center").child(
                            div.class("col-lg-6 order-lg-2").child(
                                div.class("p-5").child(
                                    img.class("img-thumbnail rounded").src("assets/images/small/small-1.jpg").alt("")
                                )
                            ),
                            div.class("col-lg-6 order-lg-1").child(
                                div.class("p-5").child(
                                    h2.class("display-4").child(
                                        "For those about to rock..."
                                    ),
                                    p.child(
                                        "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quod aliquid, mollitia odio veniam sit iste esse assumenda amet aperiam exercitationem, ea animi blanditiis recusandae! Ratione voluptatum molestiae adipisci, beatae obcaecati."
                                    )
                                )
                            )
                        )
                    )
                ),
                section.child(
                    div.class("container").child(
                        div.class("row align-items-center").child(
                            div.class("col-lg-6").child(
                                div.class("p-5").child(
                                    img.class("img-thumbnail rounded").src("assets/images/small/small-2.jpg").alt("")
                                )
                            ),
                            div.class("col-lg-6").child(
                                div.class("p-5").child(
                                    h2.class("display-4").child(
                                        "We salute you!"
                                    ),
                                    p.child(
                                        "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quod aliquid, mollitia odio veniam sit iste esse assumenda amet aperiam exercitationem, ea animi blanditiis recusandae! Ratione voluptatum molestiae adipisci, beatae obcaecati."
                                    )
                                )
                            )
                        )
                    )
                ),
                section.child(
                    div.class("container").child(
                        div.class("row align-items-center").child(
                            div.class("col-lg-6 order-lg-2").child(
                                div.class("p-5").child(
                                    img.class("img-thumbnail rounded").src("assets/images/small/small-3.jpg").alt("")
                                )
                            ),
                            div.class("col-lg-6 order-lg-1").child(
                                div.class("p-5").child(
                                    h2.class("display-4").child(
                                        "Let there be rock!"
                                    ),
                                    p.child(
                                        "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quod aliquid, mollitia odio veniam sit iste esse assumenda amet aperiam exercitationem, ea animi blanditiis recusandae! Ratione voluptatum molestiae adipisci, beatae obcaecati."
                                    )
                                )
                            )
                        )
                    )
                ),

                footer.child("py-5 bg-black").child(
                    div.class("container").child(
                        p.class("m-0 text-center text-white small").child(
                            "Copyright © Your Website 2019"
                        )
                    )
                )
            ),
            withPath: \Context.base)
    }
}
