import BootstrapKit

protocol MultipleSelectItemRepresentable {
    var itemName: String { get }
    var idRepresentable: String { get }
}

struct MultipleSelect: HTMLComponent, AttributeNode, FormInput {

    @TemplateValue([MultipleSelectItemRepresentable].self)
    var items

    private let placeholder: HTML
    var attributes: [HTMLAttribute]
    private var isSelected: (TemplateValue<MultipleSelectItemRepresentable>) -> Conditionable

    init<T>(items: TemplateValue<[T]>, id: HTML) where T: MultipleSelectItemRepresentable {
        self.placeholder = ""
        self.attributes = [HTMLAttribute(attribute: "id", value: id)]
        self.isSelected = { _ in false }
        self.items = items.unsafeCast(to: [MultipleSelectItemRepresentable].self)
    }

    init(items: TemplateValue<[MultipleSelectItemRepresentable]>, placeholder: HTML, attributes: [HTMLAttribute], isSelected: @escaping (TemplateValue<MultipleSelectItemRepresentable>) -> Conditionable) {
        self.placeholder = placeholder
        self.attributes = attributes
        self.isSelected = isSelected
        self.items = items
    }

    var body: HTML {
        guard self.value(of: "id") != nil else {
            fatalError("Missing identifier on Input")
        }

        return Select {
            ForEach(in: items) { item in
                Option {
                    item.itemName
                }
                .value(item.idRepresentable)
                .isSelected(isSelected(item))
            }
        }
        .class("form-control select2-multiple")
        .data(for: "toggle", value: "select2")
        .data(for: "placeholder", value: placeholder)
        .isMultiple(true)
        .add(attributes: attributes)
    }

    func placeholder(_ placeholder: () -> HTML) -> MultipleSelect {
        .init(items: items, placeholder: placeholder(), attributes: attributes, isSelected: isSelected)
    }

    func isSelected(_ isSelected: @escaping (TemplateValue<MultipleSelectItemRepresentable>) -> Conditionable) -> MultipleSelect {
        .init(items: items, placeholder: placeholder, attributes: attributes, isSelected: isSelected)
    }

    func copy(with attributes: [HTMLAttribute]) -> MultipleSelect {
        .init(items: items, placeholder: placeholder, attributes: attributes, isSelected: isSelected)
    }
}
