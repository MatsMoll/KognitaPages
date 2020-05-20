//
//  CollapsableCard.swift
//  KognitaViews
//
//  Created by Mats Mollestad on 12/12/2019.
//

import BootstrapKit

struct CollapsingCard: HTML, AttributeNode {

    func render<T>(with manager: HTMLRenderer.ContextManager<T>) throws -> String {
        try body.render(with: manager)
    }

    func prerender(_ formula: HTMLRenderer.Formula) throws {
        try body.prerender(formula)
    }

    private let id: HTML
    private let header: HTML
    private let contentNode: AddableAttributeNode
    private let isShown: Conditionable

    var attributes: [HTMLAttribute]

    var body: HTML {
        Div {
            Anchor {
                Span {
                    Italic().class("mdi mdi-chevron-down accordion-arrow")
                }
                .float(.right)

                header
            }
            .class("card-body")
            .data(for: "toggle", value: "collapse")
            .data(for: "target", value: id)
            .aria(for: "controls", value: id)

            contentNode
                .class("collapse" + IF(isShown) { " show" })
                .id(id)
        }
        .class("card")
        .add(attributes: attributes)
    }

    init(@HTMLBuilder header: () -> HTML) {
        self.id = "CollapsingCard"
        self.header = header()
        self.contentNode = Div()
        self.isShown = false
        attributes = []
    }

    init(id: HTML, header: HTML, content: AddableAttributeNode, isShown: Conditionable, attributes: [HTMLAttribute]) {
        self.id = id
        self.header = header
        self.contentNode = content
        self.isShown = isShown
        self.attributes = attributes
    }

    func copy(with attributes: [HTMLAttribute]) -> CollapsingCard {
        .init(id: id, header: header, content: contentNode, isShown: isShown, attributes: attributes)
    }

    func content(content: () -> AddableAttributeNode) -> CollapsingCard {
        .init(id: id, header: header, content: content(), isShown: isShown, attributes: attributes)
    }

    func collapseId(_ id: HTML) -> CollapsingCard {
        .init(id: id, header: header, content: contentNode, isShown: isShown, attributes: attributes)
    }

    func isShown(_ condition: Conditionable) -> CollapsingCard {
        .init(id: id, header: header, content: contentNode, isShown: condition, attributes: attributes)
    }
}
