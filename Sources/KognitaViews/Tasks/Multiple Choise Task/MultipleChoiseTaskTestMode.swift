
import BootstrapKit
import KognitaCore


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
        //            actionCard
                TaskNavigation(tasksIDs: context.task.testTasks)
            }
        }
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
                .style(.heading4)
                .text(color: .dark)

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
