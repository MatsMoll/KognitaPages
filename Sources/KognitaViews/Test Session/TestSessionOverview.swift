import BootstrapKit
import KognitaCore

extension TestSession {
    public enum Templates {}
}

extension TestSession.Overview {

    var finishUri: String {
        "/test-sessions/\(sessionID)/finnish"
    }
}

extension TestSession.Templates {
    public struct Overview: HTMLTemplate {

        public struct Context {
            let user: User
            let overview: TestSession.Overview

            var unansweredTasks: [TestSession.Overview.Task] {
                overview.tasks.filter({ $0.isAnswered == false })
            }

            public init(user: User, overview: TestSession.Overview) {
                self.user = user
                self.overview = overview
            }
        }

        public init() {}

        public var body: HTML {
            BaseTemplate(
                context: .constant(BaseTemplateContent(title: "Oversikt", description: "Oversikt"))
            ) {
                Container {
                    PageTitle(title: context.overview.test.title)

                    ContentStructure {
                        Text { "Oversikt" }
                            .style(.heading3)
                            .text(color: .dark)

                        IF(context.unansweredTasks.isEmpty == false) {
                            Text { "Ubesvarte oppgaver" }
                                .style(.heading4)
                                .text(color: .secondary)

                            Row {
                                ForEach(in: context.unansweredTasks) { task in
                                    Div { TaskCard(overview: task) }
                                        .column(width: .six, for: .large)
                                }
                            }
                        }
                        Text { "Alle oppgaver" }
                            .style(.heading4)
                            .text(color: .secondary)

                        Row {
                            ForEach(in: context.overview.tasks) { task in
                                Div { TaskCard(overview: task) }
                                    .column(width: .six, for: .large)
                            }
                        }
                    }
                    .secondary {
                        SubmitCard(
                            overview: context.overview
                        )
                    }
                }
            }
        }

        struct TaskCard: HTMLComponent {

            let overview: TemplateValue<TestSession.Overview.Task>

            var body: HTML {
                Card {

                    IF(overview.isAnswered) {
                        Badge {
                            "Avgitt svar "
                            MaterialDesignIcon(icon: .check)
                        }
                        .background(color: .light)
                    }.else {
                        Badge {
                            "IKKE avgitt svar "
                            MaterialDesignIcon(icon: .close)
                        }
                        .background(color: .danger)
                    }

                    Text {
                        overview.question
                    }
                    .style(.heading3)
                    .text(color: .dark)

                    Anchor {
                        "Se oppgave"
                    }
                    .button(style: .light)
                    .href(overview.testTaskID)
                }
            }
        }

        struct SubmitCard: HTMLComponent {

            let overview: TemplateValue<TestSession.Overview>

            var body: HTML {
                Card {
                    Text {
                        "Vil du levere?"
                    }
                    .style(.heading3)
                    .text(color: .dark)

                    Form {
                        Button {
                            "Lever prøve"
                        }
                        .button(style: .primary)
                        .type(.submit)
                    }
                    .action(overview.finishUri)
                    .method(.post)
                }
            }
        }
    }
}
