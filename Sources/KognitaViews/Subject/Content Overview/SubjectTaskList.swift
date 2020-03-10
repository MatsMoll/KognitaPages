import BootstrapKit
import KognitaCore

extension Subject.Templates {

    public struct TaskList: HTMLTemplate {

        public struct Context {
            let userID: User.ID?
            let isModerator: Bool
            let tasks: [CreatorTaskContent]

            public init(userID: User.ID, isModerator: Bool, tasks: [CreatorTaskContent]) {
                self.userID = userID
                self.isModerator = isModerator
                self.tasks = tasks
            }
        }

        public var context: TemplateValue<Subject.Templates.TaskList.Context> = .root()

        public var body: HTML {
            IF(context.tasks.isEmpty) {
                Div {
                    Text {
                        "Vi finner ingen oppgaver"
                    }
                    .style(.heading5)

                    Text {
                        "Kanskje du skal lage en?"
                    }
                    .style(.heading4)
                }
                .column(width: .twelve)
            }.else {

                Div {
                    Text {
                        "Antall oppgaver: "
                        context.tasks.count
                    }
                    .style(.heading5)
                }
                .column(width: .twelve)

                ForEach(in: context.tasks) { (task: TemplateValue<CreatorTaskContent>) in
                    Div {
                        TaskCell(
                            canEdit: context.isModerator || context.userID == task.creator.id,
                            task: task
                        )
                    }
                    .column(width: .twelve)
                }
            }
        }
    }

    private struct TaskCell: HTMLComponent {

        let canEdit: Conditionable
        let task: TemplateValue<CreatorTaskContent>

        var body: HTML {
            Card {

                IF(task.IsMultipleChoise) {
                    Badge {
                        "Flervalg "
                        MaterialDesignIcon(.formatListBulleted)
                    }
                    .background(color: .light)
                }.else {
                    Badge {
                        "Innskriving "
                        MaterialDesignIcon(.messageReplyText)
                    }
                    .background(color: .info)
                }

                Unwrap(task.task.deletedAt) { deletedAt in
                    Badge {
                        "Slettet: "
                        deletedAt.style(date: .short, time: .none)
                    }
                    .background(color: .danger)
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
                    "Tema: "
                    task.topic.name
                }
                .margin(.one, for: .vertical)

                Text {
                    task.task.question
                }
                .style(.heading4)

                Text {
                    "Laget av: "
                    task.creator.username
                }

                IF(canEdit) {
                    Anchor {
                        "Rediger"
                    }
                    .href(task.editUri)
                    .button(style: .light)
                }

                IF(canEdit && task.task.deletedAt.isNotDefined) {
                    Button {
                        Italic().class("dripicons-document-delete")
                        " Slett"
                    }
                    .on(click: task.deleteCall)
                    .button(style: .danger)
                    .margin(.two, for: .left)
                }
            }
        }
    }
}
