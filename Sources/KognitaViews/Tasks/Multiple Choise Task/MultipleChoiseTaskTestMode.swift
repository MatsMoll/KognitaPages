
import BootstrapKit
import KognitaCore

extension SubjectTest.TestTask {

    var navigateToCall: String { "navigateTo(\(self.testTaskID))" }
    var url: String { "javascript:\(navigateToCall)" }

    struct PageItem: PageItemRepresentable {
        let title: String
        let url: String
        var isActive: Bool
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

extension Array where Element == SubjectTest.TestTask {
    var pageItems: [SubjectTest.TestTask.PageItem] {
        enumerated()
            .map { index, item in
                SubjectTest.TestTask.PageItem(
                    title: "\(index + 1)",
                    url: item.url,
                    isActive: item.isCurrent
                )
        } + [
            SubjectTest.TestTask.PageItem(
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
                ContentStructure {
                    QuestionCard(task: context.task.task)
                    ActionCard(task: context.task)
                }
                .secondary {
                    TaskNavigation(tasksIDs: context.task.testTasks)
                }
            }
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
            Card {
                Text {
                    "Oppgave liste"
                }
                .style(.heading4)
                .text(color: .dark)

                Pagination(items: tasksIDs.pageItems)
                    .isRounded(true)
            }
            .padding(.three, for: .bottom)
        }
    }
}
