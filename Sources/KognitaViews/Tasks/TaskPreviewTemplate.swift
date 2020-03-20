//
//  TaskPreviewTemplate.swift
//  App
//
//  Created by Mats Mollestad on 23/03/2019.
//

import BootstrapKit
import KognitaCore

struct TaskPreviewTemplateContext {
    let practiceProgress: Int
    let session: PracticeSessionRepresentable
    let taskContent: TaskPreviewContent
    let lastResult: TaskResultContent?
    let user: UserContent
    let taskPath: String
    let currentTaskIndex: Int


    var subject: Subject { return taskContent.subject }
    var topic: Topic { return taskContent.topic }
    var task: Task { return taskContent.task }

    var nextTaskIndex: Int {
        currentTaskIndex + 1
    }
    var nextTaskCall: String {
        "navigateTo(\(nextTaskIndex))"
    }

    var prevTaskIndex: Int? {
        guard currentTaskIndex > 1 else {
            return nil
        }
        return currentTaskIndex - 1
    }

    public init(
        task: TaskPreviewContent,
        user: UserContent,
        practiceProgress: Int,
        session: PracticeSessionRepresentable,
        taskPath: String,
        currentTaskIndex: Int,
        lastResult: TaskResultContent?
    ) {
        self.practiceProgress = practiceProgress
        self.session = session
        self.taskContent = task
        self.user = user
        self.taskPath = taskPath
        self.currentTaskIndex = currentTaskIndex
        self.lastResult = lastResult
    }
}

extension Script {
    static func solutionScore(editorName: String) -> String {
"""
let parser = new DOMParser(); let htmlDoc = parser.parseFromString(renderMarkdown(\(editorName).value()), 'text/html');
let hrefs = new Set(Array.from(htmlDoc.getElementsByTagName("a")).map(x => x.getAttribute("href"))); let imgs = new Set(Array.from(htmlDoc.getElementsByTagName("img")).map(x => x.getAttribute("src"))); let lists = Array.from(htmlDoc.getElementsByTagName("li")); let text = htmlDoc.getElementsByTagName("body")[0].innerText.split(/\\s+/); var totalPoints = 0; totalPoints += Math.min(hrefs.size * 3, 4); totalPoints += Math.min(imgs.size * 2, 3); totalPoints += Math.min(lists.length, 1); totalPoints += (text.length < 150 && text.length > 60) ? 3 : 0; var pointsString = totalPoints + " "; if (totalPoints >= 6) { pointsString += "💯"; } else if (totalPoints > 3) {pointsString += "🤔";} else {pointsString += "💩";} $("#solution-rating").text(pointsString);
"""
    }
}

public struct TaskPreviewTemplate: HTMLComponent {

    let context: TemplateValue<TaskPreviewTemplateContext>
    let actionCard: HTML
    var underSolutionCard: HTML = ""
    var customScripts: HTML = ""

    init(context: TemplateValue<TaskPreviewTemplateContext>, @HTMLBuilder actionCard: () -> HTML) {
        self.context = context
        self.actionCard = actionCard()
        self.underSolutionCard = ""
        self.customScripts = ""
    }

    init(context: TemplateValue<TaskPreviewTemplateContext>, actionCard: HTML, underSolutionCard: HTML, customScripts: HTML) {
        self.context = context
        self.actionCard = actionCard
        self.underSolutionCard = underSolutionCard
        self.customScripts = customScripts
    }

    func underSolutionCard(@HTMLBuilder _ card: () -> HTML) -> TaskPreviewTemplate {
        TaskPreviewTemplate(context: context, actionCard: actionCard, underSolutionCard: card(), customScripts: customScripts)
    }

    func scripts(@HTMLBuilder _ scripts: () -> HTML) -> TaskPreviewTemplate {
        TaskPreviewTemplate(context: context, actionCard: actionCard, underSolutionCard: underSolutionCard, customScripts: scripts())
    }

    public var body: HTML {
        BaseTemplate(context: .init(
            title: "Oppgave",
            description: "Lær ved å øve"
        )) {
            Container {
                PageTitle(title: Strings.exerciseMainTitle.localized() + " " + context.currentTaskIndex)

                PracticeSessionProgressBar(context: context)

                Input().type(.hidden).value(context.task.id).id("task-id")

                Input()
                    .type(.hidden)
                    .value(context.task.id)
                    .id("task-id")

                Row {
                    Div {
                        Unwrap(context.task.examPaperSemester) { exam in
                            Badge {
                                Strings.exerciseExam.localized()
                                ": "
                                exam.norwegianDescription
                                " "
                                context.task.examPaperYear
                            }
                            .margin(.three, for: .bottom)
                            .background(color: .primary)
                        }
                    }
                    .column(width: .twelve)
                }

                Row {
                    Div {
                        QuestionCard(
                            description: context.taskContent.task.description,
                            question: context.taskContent.task.question
                        )
                        actionCard
                    }
                    .column(width: .seven, for: .large)

                    Div {
                        TaskSolutionCard()
                        DismissableError()
                        underSolutionCard
                        TaskDiscussionCard()
                    }
                    .column(width: .five, for: .large)
                }
                .id("main-task-content")

                Row {
                    Div {
                        NavigationCard(context: context)
                    }
                    .column(width: .twelve)
                }
                .class("fixed-bottom")
                .id("nav-card")
            }

            Modal(title: "Lag et løsningsforslag", id: "create-alternative-solution") {

                CustomControlInput(
                    label: "Vis brukernavnet",
                    type: .checkbox,
                    id: "present-user"
                )
                    .isChecked(true)
                    .margin(.two, for: .bottom)

                FormGroup(label: "Løsningsforslag") {
                    MarkdownEditor(id: "suggested-solution")
                        .placeholder("Et eller annet løsningsforslag")
                        .onChange { editor in
                            Script.solutionScore(editorName: editor)
                    }
                }
                .description { TaskSolution.Templates.Requmendations() }
                .margin(.four, for: .bottom)

                Button { "Lag løsningsforslag" }
                    .on(click: "suggestSolution()")
                    .button(style: .primary)
            }

            TaskDiscussion.Templates.CreateModal()
        }
        .header {
            Link().href("/assets/css/vendor/simplemde.min.css").relationship(.stylesheet).type("text/css")
            Link().href("/assets/css/vendor/katex.min.css").relationship(.stylesheet)
        }
        .scripts {
            Script(source: "/assets/js/vendor/simplemde.min.js")
            Script(source: "/assets/js/vendor/marked.min.js")
            Script(source: "/assets/js/vendor/katex.min.js")
            Script(source: "/assets/js/markdown-renderer.js")
            Script {
"""
$("#main-task-content").css("padding-bottom", $("#nav-card").height() + 20);
"""
            }
            customScripts
        }
    }

    struct QuestionCard: HTMLComponent {

        let description: TemplateValue<String?>
        let question: TemplateValue<String>

        var body: HTML {
            Row {
                Div {
                    Card {
                        IF(description.isDefined) {
                            Text { description.escaping(.unsafeNone) }
                                .style(.paragraph)
                                .text(color: .secondary)
                                .margin(.two, for: .bottom)
                                .class("render-markdown")
                        }
                        Text { question }
                            .style(.heading4)
                    }
                    .display(.block)
                }
                .column(width: .twelve)
            }
        }
    }

    struct NavigationCard: HTMLComponent {

        let context: TemplateValue<TaskPreviewTemplateContext>

        var body: HTML {
            Card {
                Container {
                    Form {
                        Button {
                            Strings.exerciseNextButton
                                .localized()
                            MaterialDesignIcon(.arrowRight)
                                .margin(.one, for: .left)

                        }
                        .id("nextButton")
                        .on(click: context.nextTaskCall)
                        .display(.none)
                        .float(.right)
                        .margin(.one, for: .left)
                        .button(style: .primary)
                        .type(.button)

                        Unwrap(context.prevTaskIndex) { prevTaskIndex in
                            Anchor {
                                MaterialDesignIcon(.arrowLeft)
                                    .margin(.one, for: .right)
                                "Forrige"
                            }
                            .button(style: .light)
                            .href(prevTaskIndex)
                            .margin(.two, for: .bottom)
                            .float(.left)
                        }

                        Div {
                            Button(Strings.exerciseStopSessionButton)
                                .button(style: .danger)
                        }
                        .text(alignment: .center)
                    }
                    .action("/practice-sessions/" + context.session.id + "/end")
                    .method(.post)
                }
            }
            .margin(.zero, for: .bottom)
            .padding(.two, for: .bottom)
        }
    }
}



private struct PracticeSessionProgressBar: HTMLComponent {

    let context: TemplateValue<TaskPreviewTemplateContext>

    var body: HTML {
        Row {
            Div {
                Card {
                    Text {
                        Localized(key: Strings.exerciseSessionProgressTitle)
                        Span {
                            Span {
                                context.practiceProgress
                                "% "
                            }
                            .id("goal-progress-label")

                            Small {
                                Span { context.session.numberOfTaskGoal }
                                    .id("goal-value")
                                " "
                                Localized(key: Strings.exerciseSessionProgressGoal)
                            }
                            .text(color: .muted)
                        }
                        .float(.right)
                    }
                    .style(.paragraph)
                    .font(style: .bold)
                    .margin(.two, for: .bottom)

                    ProgressBar(
                        currentValue: context.practiceProgress,
                        valueRange: 0...100
                    )
                        .bar(size: .medium)
                        .bar(id: "goal-progress-bar")
                        .modify(if: context.practiceProgress >= 100) {
                            $0.bar(style: .success)
                    }
                    .margin(.two, for: .bottom)
                }
            }
            .column(width: .twelve)
        }
    }
}


typealias StaticView = HTMLComponent
typealias TemplateView = HTMLTemplate
