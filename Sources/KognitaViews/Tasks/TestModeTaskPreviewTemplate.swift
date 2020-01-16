
import KognitaCore
import BootstrapKit

extension SubjectTest.TestTask {
    var navigateToCall: String {
        "navigateTo(\(testTaskID));"
    }
}


struct TestModeTaskPreviewTemplate: HTMLComponent {

    struct Context {
        let test: SubjectTest
        let task: Task
        let taskIDs: [SubjectTest.TestTask]

        var baseContext: BaseTemplateContent { .init(title: test.title, description: test.title) }
    }

    let context: TemplateValue<Context>
    var actionCard: HTML = Div()

    var body: HTML {
        BaseTemplate(context: context.baseContext) {
            PageTitle(title: context.test.title)
            QuestionCard(task: context.task)
            actionCard
            TaskNavigation(tasksIDs: context.taskIDs)
        }
    }

    func actionCard(@HTMLBuilder builder: () -> HTML) -> TestModeTaskPreviewTemplate {
        TestModeTaskPreviewTemplate(context: context, actionCard: builder())
    }

    struct QuestionCard: HTMLComponent {

        let task: TemplateValue<Task>

        var body: HTML {
            Row {
                Div {
                    Card {
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

    struct TaskNavigation: HTMLComponent {

        let tasksIDs: TemplateValue<[SubjectTest.TestTask]>

        var body: HTML {
            Container {
                Text {
                    "Oppgaver"
                }
                .style(.heading3)

//                ForEach(enumerated: tasksIDs) { index, task in
//                    Button {
//                        "Nr. "
//                        index
//                    }
//                    .on(click: task.navigateToCall)
//                }
            }
        }
    }
}
