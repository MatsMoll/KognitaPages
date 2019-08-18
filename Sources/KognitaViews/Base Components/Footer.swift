//
//  Footer.swift
//  App
//
//  Created by Mats Mollestad on 26/02/2019.
//
// swiftlint:disable line_length nesting

import HTMLKit

class Footer: LocalizedTemplate {

    static var localePath: KeyPath<NoContext, String>?

    enum LocalizationKeys: String {
        case copyright = "footer.copyright"
        case aboutUs = "footer.about.us"
        case help = "footer.help"
        case contact = "footer.contact"
    }

    typealias Context = NoContext

    func build() -> CompiledTemplate {
        return
            footer.class("footer").child(
                div.class("container-fluid").child(
                    div.class("row").child(
                        div.class("col-md-6").child(
                            localize(.copyright)
                        ),
                        div.class("col-md-6").child(
                            div.class("text-md-right footer-links d-none d-md-block").child(
                                a.href("javascript:%20void(0);").child(
                                    localize(.aboutUs)
                                ),
                                a.href("javascript:%20void(0);").child(
                                    localize(.help)
                                ),
                                a.href("javascript:%20void(0);").child(
                                    localize(.contact)
                                )
                            )
                        )
                    )
                )
        )
    }
}
