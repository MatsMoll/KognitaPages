
import BootstrapKit
import KognitaCore

fileprivate struct TopicTasks {
    let topic: Topic
    let tasks: [CreatorTaskContent]
}

extension Subject.Templates {
    public struct ContentOverview: HTMLTemplate {

        public struct Context {
            let user: User
            let subject: Subject
            let totalNumberOfTasks: Int

            fileprivate let grouped: [TopicTasks]

            public init(user: User, subject: Subject, tasks: [CreatorTaskContent]) {
                self.user = user
                self.subject = subject
                var totalNumberOfTasks = 0

                self.grouped = tasks.group(by: \.topic.id)
                    .compactMap { (topicId, tasks) in
                        if let topic = tasks.first?.topic {
                            totalNumberOfTasks += tasks.count
                            return TopicTasks(
                                topic: topic,
                                tasks: tasks
                            )
                        } else {
                            return nil
                        }
                }
                self.totalNumberOfTasks = totalNumberOfTasks
            }
        }

        public init() {}

        var createMultipleTaskUrl: HTML { "/creator/subjects/" + context.subject.id + "/task/multiple/create" }
        var createFlashCardTaskUrl: HTML { "/creator/subjects/" + context.subject.id + "/task/flash-card/create" }

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(
                    title: "Innhold oversikt",
                    description: "Innhold oversikt")
                )
            ) {
                Row {
                    Div {
                        Card {
                            Text {
                                context.subject.name
                            }
                            .style(.heading2)
                            .text(color: .dark)

                            Text {
                                context.totalNumberOfTasks
                                " oppgaver"
                            }
                            .text(color: .secondary)

                            Div {
                                context.subject.description
                                    .escaping(.unsafeNone)
                            }
                            .margin(.two, for: .bottom)

                            Anchor {
                                "Lag et tema"
                            }
                            .href("/creator/subjects/" + context.subject.id + "/topics/create")
                            .button(style: .primary)

                            Anchor {
                                "Lag flervalgsoppgave"
                            }
                            .href(createMultipleTaskUrl)
                            .button(style: .success)
                            .margin(.two, for: .left)

                            Anchor {
                                "Lag kortsvarsoppgave"
                            }
                            .href(createFlashCardTaskUrl)
                            .button(style: .success)
                            .margin(.two, for: .left)
                        }
                    }
                    .column(width: .twelve)
                }
                .margin(.five, for: .top)

                Row {
                    ForEach(in: context.grouped) { tasks in
                        Div {
                            TopicCard(
                                topicTasks: tasks
                            )
                        }
                        .column(width: .six)
                    }
                }
            }
            .scripts {
                Script().source("/assets/js/delete-task.js")
            }
        }
    }
}

private struct TopicCard<T>: HTMLComponent {

    let topicTasks: TemplateValue<T, TopicTasks>

    var editUrl: HTML { "/creator/subjects/" + topicTasks.topic.subjectId + "/topics/" + topicTasks.topic.id + "/edit" }

    var body: HTML {
        CollapsingCard {
            Text {
                topicTasks.topic.name
            }
            .style(.heading3)
            .text(color: .dark)

            Text {
                topicTasks.tasks.count
                " oppgaver"
            }
            .text(color: .secondary)
        }
        .content {
            Div {
                ForEach(in: topicTasks.tasks) { task in
                    TaskCell(
                        task: task
                    )
                }
            }
            .class("list-group list-group-flush")
        }
        .collapseId("collapse" + topicTasks.topic.id)
    }
}

private struct TaskCell<T>: HTMLComponent {

    let task: TemplateValue<T, CreatorTaskContent>

    var editUrl: HTML { "/creator/" + task.taskTypePath + "/" + task.task.id + "/edit" }

    var body: HTML {
        Div {
            IF(isDefined: task.task.deletedAt) { deletedAt in
                Badge {
                    "Slettet: "
                    deletedAt.style(date: .short, time: .none)
                }
                .background(color: .danger)
            }
            .else {
                Badge {
                    "Aktiv"
                }
                .background(color: .success)
            }

            IF(task.IsMultipleChoise) {
                Badge {
                    "Flervalg"
                }
                .background(color: .info)
                .margin(.one, for: .left)
            }.else {
                Badge {
                    "Innskriving"
                }
                .background(color: .info)
                .margin(.one, for: .left)
            }

            Text {
                task.task.question
            }
            .style(.heading4)

            Div {
                Anchor {
                    "Se mer"
                }
                .href(editUrl)
                .button(style: .light)

                IF(task.task.deletedAt.isNotDefined) {
                    Button {
                        Italic().class("dripicons-document-delete")
                        " Slett"
                    }
                    .on(click: "deleteTask(" + task.task.id + ", \"" + task.taskTypePath + "\");")
                    .button(style: .danger)
                    .margin(.two, for: .left)
                }
            }
            .float(.right)

            Text {
                "Laget av: "
                task.creator.username
            }
        }
        .class("list-group-item")
    }
}
