import BootstrapKit
import Foundation

extension Date {
    var iso8601: String {
        ISO8601DateFormatter().string(from: self)
    }
}

struct Spinner: HTMLComponent, AttributeNode {

    var attributes: [HTMLAttribute]

    init() {
        attributes = []
    }

    private init(attributes: [HTMLAttribute]) {
        self.attributes = attributes
    }

    var body: HTML {
        Div()
            .class("spinner-grow spinner-grow-sm")
            .role("status")
            .add(attributes: attributes)
    }

    func copy(with attributes: [HTMLAttribute]) -> Spinner {
        .init(attributes: attributes)
    }
}

extension SubjectTest.AssignedTask {

    var url: String { "\(testTaskID)" }

    struct PageItem: PageItemRepresentable {
        let title: String
        let url: String
        var isActive: Bool
    }
}

extension SubjectTest.MultipleChoiseTaskContent {

    var prevTask: SubjectTest.AssignedTask? {
        guard
            let currentIndex = testTasks.firstIndex(where: { $0.isCurrent }),
            currentIndex > 0
        else {
            return nil
        }
        return testTasks[currentIndex - 1]
    }

    var nextTask: SubjectTest.AssignedTask? {
        guard
            let currentIndex = testTasks.firstIndex(where: { $0.isCurrent }),
            currentIndex < testTasks.count - 1
        else {
            return nil
        }
        return testTasks[currentIndex + 1]
    }
}

extension Array where Element == SubjectTest.AssignedTask {
    var pageItems: [SubjectTest.AssignedTask.PageItem] {
        enumerated()
            .map { index, item in
                SubjectTest.AssignedTask.PageItem(
                    title: "\(index + 1)",
                    url: item.url,
                    isActive: item.isCurrent
                )
        } + [
            SubjectTest.AssignedTask.PageItem(
                title: "Oversikt",
                url: "overview",
                isActive: false
            )
        ]
    }
}

public struct MultipleChoiseTaskTestMode: HTMLTemplate {

    public struct Context {
        let user: User
        let task: SubjectTest.MultipleChoiseTaskContent
        var baseContext: BaseTemplateContent { .init(title: "", description: "", showCookieMessage: false) }
        var renderedAt: Date { .now }

        public init(user: User, task: SubjectTest.MultipleChoiseTaskContent) {
            self.user = user
            self.task = task
        }
    }

    public init() {}

    public var body: HTML {
        BaseTemplate(context: context.baseContext) {
            Container {
                PageTitle(title: context.task.test.title)

                Unwrap(context.task.test.endedAt) { endsAt in
                    Input()
                        .value(endsAt.iso8601)
                        .id("ends-at")
                        .type(.hidden)
                }

                Input()
                    .value(context.renderedAt.iso8601)
                    .id("rendered-at")
                    .type(.hidden)

                QuestionCard(task: context.task.task)
                ActionCard(task: context.task)

                TaskNavigation(tasksIDs: context.task.testTasks)
            }
        }
        .scripts {
            Script(source: "https://cdn.jsdelivr.net/npm/marked/marked.min.js")
            Script().source("https://cdn.jsdelivr.net/npm/katex@0.11.1/dist/katex.min.js")
            Script(source: "/assets/js/markdown-renderer.js")
            Script(source: "/assets/js/test-session/json-data.js")
            Script(source: "/assets/js/test-session/save.js")
        }
        .header {
            Stylesheet(url: "https://cdn.jsdelivr.net/npm/katex@0.11.1/dist/katex.min.css")
        }
    }

    struct QuestionCard: HTMLComponent {

        let task: TemplateValue<MultipleChoiceTask>

        var body: HTML {
            Row {
                Div {
                    Text {
                        "Oppgave"
                    }
                    .style(.heading3)

                    Card {
                        Badge {
                            "Tid igjen: "
                            Span().id("time-left")
                        }
                        .background(color: .primary)
                        .float(.right)
                        .id("time-left-badge")

                        Small {
                            "Les spørsmålet og velg passende svar"
                        }

                        IF(task.description.isDefined) {
                            Div {
                                task.description
                                    .escaping(.unsafeNone)
                            }
                            .id("task-description")
                            .margin(.two, for: .top)
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
                        canSelectMultiple: task.task.isMultipleSelect,
                        choise: choise
                    )
                }

                Div {
                    Badge {
                        MaterialDesignIcon(.check)
                            .id("save-status-icon")

                        Div()
                            .id("save-status-spinner")
                            .display(.none)

                        Span {
                            "Lagret"
                        }
                        .margin(.one, for: .left)
                        .id("save-status")
                    }
                    .background(color: .success)
                    .id("save-status-badge")
                    .margin(.two, for: .vertical)
                }
                .display(.block)

                Unwrap(task.prevTask) { task in
                    Anchor { "Forrige" }
                        .button(style: .light)
                        .href(task.url)
                        .margin(.one, for: .right)
                }
                .else {
                    Anchor { "Forrige" }
                        .button(style: .light)
                        .margin(.one, for: .right)
                }

                Unwrap(task.nextTask) { task in
                    Anchor { "Neste" }
                        .button(style: .primary)
                        .href(task.url)
                }
                .else {
                    Anchor { "Oversikt" }
                        .button(style: .primary)
                        .href("overview")
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

        let tasksIDs: TemplateValue<[SubjectTest.AssignedTask]>

        var body: HTML {
            Card {
                Text {
                    "Oppgaveliste"
                }
                .style(.heading4)
                .text(color: .dark)

                Pagination(items: tasksIDs.pageItems)
                    .isRounded(true)
            }
        }
    }
}
