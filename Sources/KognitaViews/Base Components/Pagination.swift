import BootstrapKit


protocol PageItemRepresentable {
    var url: String { get }
    var title: String { get }
    var isActive: Bool { get }
}


extension Array where Element: PageItemRepresentable {
    var lastPageItem: Element? {
        guard
            let currentIndex = self.firstIndex(where: { $0.isActive }),
            currentIndex > 0
        else {
            return nil
        }
        return self[currentIndex - 1]
    }

    var nextPageItem: Element? {
        guard
            let currentIndex = self.firstIndex(where: { $0.isActive }),
            currentIndex < self.count - 1
        else {
            return nil
        }
        return self[currentIndex + 1]
    }
}

struct Pagination<T: PageItemRepresentable>: HTMLComponent, AttributeNode {

    let items: TemplateValue<[T]>
    let isRounded: Conditionable
    var attributes: [HTMLAttribute]

    init(items: TemplateValue<[T]>) {
        self.items = items
        self.isRounded = false
        self.attributes = []
    }

    private init(items: TemplateValue<[T]>, isRounded: Conditionable, attributes: [HTMLAttribute]) {
        self.items = items
        self.isRounded = isRounded
        self.attributes = attributes
    }

    var body: HTML {
        Nav {
            UnorderedList {
                prevButton()
                ForEach(in: items) { item in
                    PageItem(item: item)
                }
                nextButton()
            }
            .class("pagination")
            .modify(if: isRounded) {
                $0.class("pagination-rounded")
            }
        }
        .add(attributes: attributes)
    }

    func prevButton() -> HTML {
        Unwrap(items.lastPageItem) { item in
            PageItem(item: item) {
                Span {
                    "«"
                }
                .aria("hidden", value: true)
                Span {
                    "Previous"
                }
                .class("sr-only")
            }
        }
        .else {
            PageItem(item: .constant(DefaultItems.disabled)) {
                Span {
                    "«"
                }
                .aria("hidden", value: true)
                Span {
                    "Previous"
                }
                .class("sr-only")
            }
            .isDisabled()
        }
    }

    func nextButton() -> HTML {
        Unwrap(items.nextPageItem) { item in
            PageItem(item: item) {
                Span {
                    "»"
                }
                .aria("hidden", value: true)
                Span {
                    "Next"
                }
                .class("sr-only")
            }
        }.else {
            PageItem(item: .constant(DefaultItems.disabled)) {
                Span {
                    "»"
                }
                .aria("hidden", value: true)
                Span {
                    "Next"
                }
                .class("sr-only")
            }
            .isDisabled()
        }
    }


    func isRounded(_ condition: Conditionable) -> Pagination {
        .init(items: items, isRounded: condition, attributes: attributes)
    }

    func copy(with attributes: [HTMLAttribute]) -> Pagination {
        .init(items: items, isRounded: isRounded, attributes: attributes)
    }

    struct DefaultItems: PageItemRepresentable {
        let url: String
        let title: String
        let isActive: Bool = false

        static var disabled: DefaultItems {
            DefaultItems(
                url: "#",
                title: "#"
            )
        }
    }

    struct PageItem<V: PageItemRepresentable>: HTMLComponent {

        let item: TemplateValue<V>
        let customTitle: HTML?
        private let isDisabled: Conditionable

        init(item: TemplateValue<V>) {
            self.item = item
            self.customTitle = nil
            self.isDisabled = false
        }

        init(item: TemplateValue<V>, @HTMLBuilder customTitle: () -> HTML) {
            self.item = item
            self.customTitle = customTitle()
            self.isDisabled = false
        }

        private init(item: TemplateValue<V>, customTitle: HTML?, isDisabled: Conditionable) {
            self.item = item
            self.customTitle = customTitle
            self.isDisabled = isDisabled
        }

        var body: HTML {
            ListItem {
                IF(customTitle == nil) {
                    Anchor {
                        item.title
                    }
                    .class("page-link")
                    .href(item.url)
                }.else {
                    Anchor {
                        customTitle ?? Div()
                    }
                    .class("page-link")
                    .href(item.url)
                }
            }
            .class("page-item")
            .modify(if: item.isActive) {
                $0.class("active")
            }
            .modify(if: isDisabled) {
                $0.class("disabled")
            }
        }

        func isDisabled(_ condition: Conditionable = true) -> PageItem {
            .init(item: item, customTitle: customTitle, isDisabled: condition)
        }
    }
}

