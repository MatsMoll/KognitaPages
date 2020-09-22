//
//  HTML+Dragula.swift
//  KognitaViews
//
//  Created by Mats Mollestad on 07/09/2020.
//

import HTMLKit

struct AddedScript: HTML {
    let content: HTML
    let scripts: HTML

    func render<T>(with manager: HTMLRenderer.ContextManager<T>) throws -> String {
        try content.render(with: manager)
    }

    func prerender(_ formula: HTMLRenderer.Formula) throws {
        try content.prerender(formula)
    }
}

extension AttributeNode {
    func dragableElements(onDrag: String? = nil) -> HTML {
        guard let id = value(of: "id") else { fatalError() }
        var script = ##"dragula([$("#\##(id)")[0]])"##
        if let onDrag = onDrag {
            script += #".on("dragend", \#(onDrag))"#
        }
        return AddedScript(
            content: self,
            scripts: NodeList {
                self.scripts
                Script { script }
            }
        )
    }
}

extension Script {
    static let dragula = Script(source: "/assets/js/vendor/dragula.min.js")
}
