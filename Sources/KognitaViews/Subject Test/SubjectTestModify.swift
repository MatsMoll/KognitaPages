import Foundation
import KognitaCore
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

extension Task: MultipleSelectItemRepresentable {
    var itemName: String { question }
    var idRepresentable: String { String(id ?? 0) }
}


extension SubjectTest.Templates {

    public struct Modify: HTMLTemplate {

        public struct Context {

            var editCall: String { "editTest(\(test?.id ?? 0))" }
            var deleteCall: String { "deleteTest(\(test?.id ?? 0))" }

            let user: User
            let tasks: [Task]
            let test: SubjectTest.ModifyResponse?

            var selectedTaskIDs: [String] {
                test?.taskIDs.map { String($0) } ?? []
            }

            public init(user: User, tasks: [Task], test: SubjectTest.ModifyResponse? = nil) {
                self.user = user
                self.tasks = tasks
                self.test = test
            }
        }

        public init() {}

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Lag temaer", description: "Lag temaer"))
            ) {
                Div {
                    DismissableError()
                    Div {
                        Div {
                            Form {

                                Unwrap(context.test) { test in
                                    Input()
                                        .type(.hidden)
                                        .value(test.subjectID)
                                        .id("subject-id")
                                }

                                FormGroup(label: "Overskrift") {
                                    Input()
                                        .id("create-test-title")
                                        .type(.text)
                                        .placeholder("TBL 1")
                                        .value(Unwrap(context.test) { $0.title })
                                }

                                Unwrap(context.test) { test in
                                    FormGroup(label: "Planlagt dato") {
                                        DatePicker()
                                            .id("create-test-scheduled-at")
                                            .selected(date: test.scheduledAt)
                                    }
                                }
                                .else {
                                    FormGroup(label: "Planlagt dato") {
                                        DatePicker()
                                            .id("create-test-scheduled-at")
                                    }
                                }

                                FormGroup(label: "Varighet (minutter)") {
                                    Input()
                                        .id("create-test-duration")
                                        .type(.number)
                                        .placeholder("10")
                                        .value(Unwrap(context.test) { $0.duration })
                                }

                                FormGroup(label: "Oppgaver") {
                                    MultipleSelect(
                                        items: context.tasks,
                                        id: "create-test-tasks"
                                    )
                                    .isSelected { item in
                                        InCollectionCondition(
                                            value: item.idRepresentable,
                                            array: self.context.selectedTaskIDs
                                        )
                                    }
                                }
                                .description {
                                    "Her vil bare oppgaver som er markert med 'ikke for øving' bli vist. Du kan lage en oppgave "
                                }

                                FormGroup(label: "Passord") {
                                    Input()
                                        .type(.text)
                                        .id("create-test-password")
                                        .placeholder("EksempelPassord")
                                        .value(Unwrap(context.test) { $0.password })
                                }

                                IF(context.test.isDefined) {
                                    Button {
                                        "Endre Test"
                                    }
                                    .on(click: context.editCall)
                                    .type(.button)
                                    .button(style: .warning)

                                    Button {
                                        "Delete Test"
                                    }
                                    .on(click: context.deleteCall)
                                    .type(.button)
                                    .button(style: .danger)
                                    .margin(.one, for: .left)
                                }
                                .else {
                                    Button {
                                        "Lagre Test"
                                    }
                                    .on(click: "createTest()")
                                    .type(.button)
                                    .button(style: .primary)
                                }
                            }
                        }.class("p-2")
                    }.class("modal-body")
                }.class("card mt-5")
            }
            .scripts {
                Script().source("/assets/js/subject-test/json-data.js").type("text/javascript")
                Script().source("/assets/js/dismissable-error.js").type("text/javascript")

                IF(context.test.isDefined) {
                    Script().source("/assets/js/subject-test/edit.js").type("text/javascript")
                    Script().source("/assets/js/subject-test/delete.js").type("text/javascript")
                }
                .else {
                    Script().source("/assets/js/subject-test/create.js").type("text/javascript")
                }
            }
        }
    }
}