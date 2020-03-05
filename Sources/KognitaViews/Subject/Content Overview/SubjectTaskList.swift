import BootstrapKit
import KognitaCore

extension Subject.Templates {

    public struct TaskList: HTMLTemplate {

        public struct Context {
            let userID: User.ID
            let tasks: [CreatorTaskContent]

            public init(userID: User.ID, tasks: [CreatorTaskContent]) {
                self.userID = userID
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

                ForEach(in: context.tasks) { task in
                    Div {
                        TaskCell(task: task)
                    }
                    .column(width: .twelve)
                }
            }
        }
    }

    private struct TaskCell: HTMLComponent {

        let task: TemplateValue<CreatorTaskContent>

        var body: HTML {
            Card {
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
        }
    }
}
