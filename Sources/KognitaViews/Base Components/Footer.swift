//
//  Footer.swift
//  App
//
//  Created by Mats Mollestad on 26/02/2019.
//
// swiftlint:disable line_length nesting

import HTMLKit
import BootstrapKit

struct CopyrightFooter: HTMLComponent {

    var body: HTML {
        Footer {
            Container(mode: .fluid) {
                Row {
                    Div {
                        P(Strings.copyright)
                    }
                    .columnWidth(6, for: .medium)
                    Div {
                        Div {
                            Anchor(Strings.footerAboutUs).href("#")
                            Anchor(Strings.footerHelp).href("#")
                            Anchor(Strings.footerContact).href("#")
                        }
                        .text(alignment: .right)
                        .class("footer-links")
                        .display(.none)
                        .display(.block, breakpoint: .medium)
                    }
                    .columnWidth(6, for: .medium)
                }
            }
        }.class("footer")
    }
}

//class Footer: LocalizedTemplate {
//
//    static var localePath: KeyPath<NoContext, String>?
//
//    enum LocalizationKeys: String {
//        case copyright = "footer.copyright"
//        case aboutUs = "footer.about.us"
//        case help = "footer.help"
//        case contact = "footer.contact"
//    }
//
//    typealias Context = NoContext
//
//    func build() -> CompiledTemplate {
//        return
//            footer.class("footer").child(
//                div.class("container-fluid").child(
//                    div.class("row").child(
//                        div.class("col-md-6").child(
//                            localize(.copyright)
//                        ),
//                        div.class("col-md-6").child(
//                            div.class("text-md-right footer-links d-none d-md-block").child(
//                                a.href("javascript:%20void(0);").child(
//                                    localize(.aboutUs)
//                                ),
//                                a.href("javascript:%20void(0);").child(
//                                    localize(.help)
//                                ),
//                                a.href("javascript:%20void(0);").child(
//                                    localize(.contact)
//                                )
//                            )
//                        )
//                    )
//                )
//        )
//    }
//}
