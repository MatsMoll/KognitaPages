
import BootstrapKit
import KognitaCore

fileprivate struct TopicTasks {
    let topic: Topic
    let tasks: [CreatorTaskContent]
}

extension Subject {
    var createMultipleTaskUri: String { "/creator/subjects/\(id ?? 0)/task/multiple/create" }
    var createFlashCardTaskUri: String { "/creator/subjects/\(id ?? 0)/task/flash-card/create" }
    var createTopicUri: String { "/creator/subjects/\(id ?? 0)/topics/create" }
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
                .sorted(by: { $0.topic.chapter < $1.topic.chapter })
                self.totalNumberOfTasks = totalNumberOfTasks
            }
        }

        var breadcrumbs: [BreadcrumbItem]  {
            [
                BreadcrumbItem(link: "/subjects", title: "Fag oversikt"),
                BreadcrumbItem(link: ViewWrapper(view: "/subjects/" + context.subject.id), title: ViewWrapper(view: context.subject.name))
            ]
        }

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(
                    title: "Innholdsoversikt",
                    description: "Innholdsoversikt")
                )
            ) {
                PageTitle(title: "Innholds oversikt", breadcrumbs: breadcrumbs)
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
                            .href(context.subject.createTopicUri)
                            .button(style: .primary)

                            Anchor {
                                "Lag flervalgsoppgave"
                            }
                            .href(context.subject.createMultipleTaskUri)
                            .button(style: .success)
                            .margin(.two, for: .left)

                            Anchor {
                                "Lag kortsvarsoppgave"
                            }
                            .href(context.subject.createFlashCardTaskUri)
                            .button(style: .success)
                            .margin(.two, for: .left)
                        }
                    }
                    .column(width: .twelve)
                }

                Row {
                    ForEach(in: context.grouped) { tasks in
                        Div {
                            TopicCard(
                                topicTasks: tasks
                            )
                        }
                        .column(width: .six, for: .large)
                        .column(width: .twelve)
                    }
                }
            }
            .scripts {
                Script(source: "/assets/js/delete-task.js")
            }
        }
    }
}

extension TopicTasks {
    var editUrl: String { "/creator/subjects/\(topic.subjectId)/topics/\(topic.id ?? 0)/edit" }
}

private struct TopicCard: HTMLComponent {

    let topicTasks: TemplateValue<TopicTasks>

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

extension CreatorTaskContent {
    var editUri: String { "/creator/\(taskTypePath)/\(task.id ?? 0)/edit" }
    var deleteCall: String { "deleteTask(\(task.id ?? 0), \"\(taskTypePath)\");" }
}

private struct TaskCell: HTMLComponent {

    let task: TemplateValue<CreatorTaskContent>

    var body: HTML {
        Div {
            Unwrap(task.task.deletedAt) { deletedAt in
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
                .background(color: .light)
                .margin(.one, for: .left)
            }.else {
                Badge {
                    "Innskriving"
                }
                .background(color: .info)
                .margin(.one, for: .left)
            }

            IF(task.task.isTestable) {
                Badge {
                    "Prøve"
                }
                .background(color: .warning)
                .margin(.one, for: .left)
            }

            Unwrap(task.task.examPaperYear) { examYear in
                Unwrap(task.task.examPaperSemester) { examSemester in
                    Badge {
                        "Eksamen: "
                        examSemester.rawValue
                        " "
                        examYear
                    }
                }
            }

            Text {
                task.task.question
            }
            .style(.heading4)

            Div {
                Anchor {
                    "Se mer"
                }
                .href(task.editUri)
                .button(style: .light)

                IF(task.task.deletedAt.isNotDefined) {
                    Button {
                        Italic().class("dripicons-document-delete")
                        " Slett"
                    }
                    .on(click: task.deleteCall)
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
