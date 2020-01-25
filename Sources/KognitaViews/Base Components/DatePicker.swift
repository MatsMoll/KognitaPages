import BootstrapKit
import Foundation

struct DatePicker: HTMLComponent, AttributeNode, FormInput {

    var attributes: [HTMLAttribute]

    @TemplateValue(Date?.self)
    private var selectedDate

    init() {
        attributes = []
    }

    private init(attributes: [HTMLAttribute], selectedDate: TemplateValue<Date?>) {
        self.attributes = attributes
        self.selectedDate = selectedDate
    }

    var body: HTML {
        Input()
            .type(.text)
            .class("date")
            .data("toggle", value: "date-picker")
            .data("single-date-picker", value: true)
            .add(attributes: attributes)
            .modify(if: selectedDate.isDefined) {
                $0.data("start-date", value: selectedDate.formatted(string: "MM/dd/yyyy"))
        }
    }

    func copy(with attributes: [HTMLAttribute]) -> DatePicker {
        .init(attributes: attributes, selectedDate: selectedDate)
    }

    func selected(date: TemplateValue<Date>) -> DatePicker {
        .init(attributes: attributes, selectedDate: date.makeOptional())
    }
}
