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
