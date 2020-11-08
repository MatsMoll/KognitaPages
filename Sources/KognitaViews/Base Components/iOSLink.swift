//
//  iOSLink.swift
//  KognitaViews
//
//  Created by Mats Mollestad on 05/11/2020.
//

import Foundation

struct LinkiOSApp: HTMLComponent, AttributeNode {

    var attributes: [HTMLAttribute] = []

    var body: HTML {
        Anchor { Img(source: "/assets/images/Download_on_the_App_Store_Badge_NO.svg").style(css: "max-width: 100%") }
            .href("https://testflight.apple.com/join/V7D9Xl82")
            .add(attributes: attributes)
    }

    func copy(with attributes: [HTMLAttribute]) -> LinkiOSApp {
        .init(attributes: attributes)
    }
}
