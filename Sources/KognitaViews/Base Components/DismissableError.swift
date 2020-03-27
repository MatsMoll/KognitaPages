//
//  DismissableError.swift
//  App
//
//  Created by Mats Mollestad on 21/08/2019.
//

import HTMLKit
import BootstrapKit

struct DismissableError: HTMLComponent {

    var body: HTML {
        Alert {
            Bold { "En Feil Oppstod - " }
            Span().id("error-massage")
        }
        .isDismissable(false)
        .background(color: .danger)
        .text(color: .white)
        .display(.none)
        .id("error-div")
    }
}
