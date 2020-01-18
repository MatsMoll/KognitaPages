
import BootstrapKit
import KognitaCore

protocol PageItemRepresentable {
    var url: String { get }
    var title: String { get }
    var isActive: Bool { get }
}

extension SubjectTest.TestTask: PageItemRepresentable {
    var url: String { "javascript:\(navigateToCall);" }
    var title: String { "\(self.testTaskID)" }
    var isActive: Bool { self.isCurrent }
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

    struct PageItem: HTMLComponent {

        private struct DefaultItems: PageItemRepresentable {
            let url: String
            let title: String
            let isActive: Bool = false
        }

        let item: TemplateValue<T>
        let customTitle: HTML?

        init(item: TemplateValue<T>) {
            self.item = item
            self.customTitle = nil
        }

        init(item: TemplateValue<T>, @HTMLBuilder customTitle: () -> HTML) {
            self.item = item
            self.customTitle = customTitle()
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
        }
    }


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
                ForEach(in: items) { item in
                    PageItem(item: item)
                }
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
                }
            }
            .class("pagination")
            .modify(if: isRounded) {
                $0.class("pagination-rounded")
            }
        }
        .add(attributes: attributes)
    }


    func isRounded(_ condition: Conditionable) -> Pagination {
        .init(items: items, isRounded: condition, attributes: attributes)
    }

    func copy(with attributes: [HTMLAttribute]) -> Pagination {
        .init(items: items, isRounded: isRounded, attributes: attributes)
    }
}

extension SubjectTest.MultipleChoiseTaskContent {

    var prevTask: SubjectTest.TestTask? {
        guard
            let currentIndex = testTasks.firstIndex(where: { $0.isCurrent }),
            currentIndex > 0
        else {
            return nil
        }
        return testTasks[currentIndex - 1]
    }

    var nextTask: SubjectTest.TestTask? {
        guard
            let currentIndex = testTasks.firstIndex(where: { $0.isCurrent }),
            currentIndex < testTasks.count - 1
        else {
            return nil
        }
        return testTasks[currentIndex + 1]
    }
}

extension Script {
    init(source: String) {
        self.init()
        attributes = [
            HTMLAttribute(attribute: "src", value: source),
            HTMLAttribute(attribute: "type", value: "text/javascript"),
        ]
    }
}


public struct MultipleChoiseTaskTestMode: HTMLTemplate {

    public struct Context {
        let user: User
        let task: SubjectTest.MultipleChoiseTaskContent
        var baseContext: BaseTemplateContent { .init(title: "", description: "") }

        public init(user: User, task: SubjectTest.MultipleChoiseTaskContent) {
            self.user = user
            self.task = task
        }
    }

    public init() {}

    public var body: HTML {
        BaseTemplate(context: context.baseContext) {
            Container {
                PageTitle(title: "Test")
                QuestionCard(task: context.task.task)
                ActionCard(task: context.task)
            }
            TaskNavigation(tasksIDs: context.task.testTasks)
        }
        .scripts {
            Script(source: "/assets/js/test-session/json-data.js")
            Script(source: "/assets/js/test-session/save.js")
        }
    }

    struct QuestionCard: HTMLComponent {

        let task: TemplateValue<Task>

        var body: HTML {
            Row {
                Div {
                    Text {
                        "Oppgave"
                    }
                    .style(.heading3)

                    Card {
                        Small {
                            "Les spørsmålet og velg passende svar"
                        }

                        IF(task.description.isDefined) {
                            Text {
                                task.description
                                    .escaping(.unsafeNone)
                            }
                            .style(.paragraph)
                            .text(color: .secondary)
                            .margin(.two, for: .bottom)
                            .margin(.three, for: .top)
                        }
                        Text {
                            task.question
                        }
                        .style(.heading5)
                        .modify(if: task.description.isNotDefined) {
                            $0.margin(.three, for: .top)
                        }
                    }
                    .display(.block)
                }
                .column(width: .twelve)
            }
        }
    }

    struct ActionCard: HTMLComponent {

        var task: TemplateValue<SubjectTest.MultipleChoiseTaskContent>

        var body: HTML {
            Card {
                Small {
                    "Velg et svar"
                }
                ForEach(in: task.choises) { choise in
                    ChoiseOption(
                        canSelectMultiple: task.isMultipleSelect,
                        choise: choise
                    )
                }

                Unwrap(task.prevTask) { task in
                    Anchor {
                        "Forrige"
                    }
                    .button(style: .light)
                    .href(task.url)
                    .margin(.one, for: .right)
                }

                Unwrap(task.nextTask) { task in
                    Anchor {
                        "Neste"
                    }
                    .button(style: .primary)
                    .href(task.url)
                }
            }
        }
    }

    struct ChoiseOption: HTMLComponent {

        let canSelectMultiple: Conditionable
        let choise: TemplateValue<SubjectTest.MultipleChoiseTaskContent.Choise>

        var body: HTML {
            Div {
                Div {
                    Div {
                        Input()
                            .name("choiseInput")
                            .class("custom-control-input")
                            .id(choise.id)
                            .modify(if: canSelectMultiple) {
                                $0.type(.checkbox)
                            }
                            .modify(if: !canSelectMultiple) {
                                $0.type(.radio)
                            }
                            .isChecked(choise.isSelected)
                        Label {
                            choise.choise
                                .escaping(.unsafeNone)
                        }
                        .class("custom-control-label")
                        .for(choise.id)
                    }
                    .class("custom-control")
                    .modify(if: canSelectMultiple) {
                        $0.class("custom-checkbox")
                    }
                    .modify(if: !canSelectMultiple) {
                        $0.class("custom-radio")
                    }
                }
                .class("p-2 text-secondary")
                .id(choise.id + "-div")
            }
            .class("card mb-1 shadow-none border")
        }
    }

    struct TaskNavigation: HTMLComponent {

        let tasksIDs: TemplateValue<[SubjectTest.TestTask]>

        var body: HTML {
            Container {
                Text {
                    "Oppgave liste"
                }
                .style(.heading4)
                .text(color: .dark)

                Pagination(items: tasksIDs)
                    .isRounded(true)
            }
            .class("fixed-bottom")
            .padding(.three, for: .bottom)
        }
    }
}
