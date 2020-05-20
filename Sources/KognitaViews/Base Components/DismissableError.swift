//
//  DismissableError.swift
//  App
//
//  Created by Mats Mollestad on 21/08/2019.
//

import HTMLKit
import BootstrapKit

struct DismissableError: HTMLComponent, AttributeNode {

    var attributes: [HTMLAttribute]
    let messageID: String

    init(divID: String = "error-div", messageID: String = "error-massage") {
        self.messageID = messageID
        self.attributes = [HTMLAttribute(attribute: "id", value: divID)]
    }

    private init(attributes: [HTMLAttribute], messageID: String) {
        self.attributes = attributes
        self.messageID = messageID
    }

    var body: HTML {
        Alert {
            Bold { "En feil oppstod - " }
            Span().id(messageID)
        }
        .isDismissable(false)
        .background(color: .danger)
        .text(color: .white)
        .display(.none)
        .add(attributes: attributes)
    }

    func copy(with attributes: [HTMLAttribute]) -> DismissableError {
        .init(attributes: attributes, messageID: messageID)
    }
}
