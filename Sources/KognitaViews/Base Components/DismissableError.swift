//
//  DismissableError.swift
//  App
//
//  Created by Mats Mollestad on 21/08/2019.
//

import HTMLKit
import BootstrapKit

struct DismissableError: StaticView {

    var body: View {
        Alert {
            Bold { "En Feil Oppstod - " }
            Span().id("error-massage")
        }
        .isDismissable(true)
        .background(color: .danger)
        .text(color: .white)
        .display(.none)
        .id("error-div")
    }
}
//struct DismissableError: StaticView {
//
//    func build() -> CompiledTemplate {
//        return div.id("error-div").class("alert alert-secondary alert-dismissible bg-danger text-white border-0 fade show d-none").child(
//            button.type("button").class("close").onclick("$(\"#error-div\").fadeOut()").ariaLabel("Close").child(
//                span.ariaHidden("true").child(
//                    "×"
//                )
//            ),
//            strong.child(
//                "En Feil Oppstod - "
//            ),
//            span.id("error-massage")
//        )
//    }
//}
