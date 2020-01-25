import HTMLKit

struct ViewWrapper: HTML {
    let view: HTML

    func render<T>(with manager: HTMLRenderer.ContextManager<T>) throws -> String {
        try view.render(with: manager)
    }

    func prerender(_ formula: HTMLRenderer.Formula) throws {
        try view.prerender(formula)
    }
}

extension ViewWrapper: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self.view = value
    }
}
