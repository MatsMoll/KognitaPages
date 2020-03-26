import BootstrapKit


@_functionBuilder
public class AttributeBuilder {
    public static func buildBlock(_ children: AddableAttributeNode...) -> [AddableAttributeNode] {
        return children
    }
}

struct MoreDropdown: HTMLComponent, AttributeNode {

    let dropdownItems: HTML
    var attributes: [HTMLAttribute]

    init(@AttributeBuilder items: () -> [AddableAttributeNode]) {
        dropdownItems = items().map { $0.class("dropdown-item") }.reduce("", +)
        attributes = []
    }

    private init(dropdownItems: HTML, attributes: [HTMLAttribute]) {
        self.dropdownItems = dropdownItems
        self.attributes = attributes
    }

    var body: HTML {

        Div {
            Anchor {
                MaterialDesignIcon(.dotsVertical)
            }
            .href("#")
            .class("dropdown-toggle arrow-none card-drop")
            .data("toggle", value: "dropdown")
            .aria("expanded", value: false)

            Div {
                dropdownItems
            }
            .class("dropdown-menu dropdown-menu-right")
        }
        .class("dropdown")
        .add(attributes: attributes)
    }

    func copy(with attributes: [HTMLAttribute]) -> MoreDropdown {
        .init(dropdownItems: dropdownItems, attributes: attributes)
    }
}
