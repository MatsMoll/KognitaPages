
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

private struct TopicCard: HTMLComponent {

    let topicTasks: TemplateValue<TopicTasks>

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

private struct TaskCell: HTMLComponent {

    let task: TemplateValue<CreatorTaskContent>

    var editUrl: HTML { "/creator/" + task.taskTypePath + "/" + task.task.id + "/edit" }

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
