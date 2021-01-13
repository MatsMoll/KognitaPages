//
//  TaskPreviewTemplate.swift
//  App
//
//  Created by Mats Mollestad on 23/03/2019.
//

import BootstrapKit

extension Sessions {
    public struct ProgressState: Codable {

        public let progress: Int
        public let numberOfTaskGoal: Int
        public let currentTaskIndex: Int
        public let sessionID: Sessions.ID

        public init(progress: Int, numberOfTaskGoal: Int, currentTaskIndex: Int, sessionID: Sessions.ID) {
            self.progress = progress
            self.numberOfTaskGoal = numberOfTaskGoal
            self.currentTaskIndex = currentTaskIndex
            self.sessionID = sessionID
        }
    }
}

struct TaskPreviewTemplateContext {
    let taskContent: TaskPreviewContent
    let progressState: Sessions.ProgressState
    let lastResult: TaskResult?
    let user: User
    let taskPath: String

    var practiceProgress: Int { progressState.progress }
    var sessionID: Sessions.ID { progressState.sessionID }
    var numberOfTaskGoal: Int { progressState.numberOfTaskGoal }
    var currentTaskIndex: Int { progressState.currentTaskIndex }

    var subject: Subject { return taskContent.subject }
    var topic: Topic { return taskContent.topic }
    var task: Task { return taskContent.task }

    var nextTaskIndex: Int {
        currentTaskIndex + 1
    }
    var nextTaskCall: String { "navigateTo(\(nextTaskIndex))" }
    var extendSessionCall: String { "extendSession()" }
    var endSessionCall: String { "endSession()" }

    var prevTaskIndex: Int? {
        guard currentTaskIndex > 1 else {
            return nil
        }
        return currentTaskIndex - 1
    }

    public init(
        task: TaskPreviewContent,
        progressState: Sessions.ProgressState,
        user: User,
        taskPath: String,
        lastResult: TaskResult?
    ) {
        self.taskContent = task
        self.user = user
        self.taskPath = taskPath
        self.lastResult = lastResult
        self.progressState = progressState
    }
}

enum ExtendSessionTypes: String {
    case exam
    case practice
}

extension Script {
    static func solutionScore(divID: String, editorName: String) -> String {
"""
let parser = new DOMParser(); let htmlDoc = parser.parseFromString(renderMarkdown(\(editorName).value()), 'text/html');
let hrefs = new Set(Array.from(htmlDoc.getElementsByTagName("a")).map(x => x.getAttribute("href"))); let imgs = new Set(Array.from(htmlDoc.getElementsByTagName("img")).map(x => x.getAttribute("src"))); let lists = Array.from(htmlDoc.getElementsByTagName("li")); let text = htmlDoc.getElementsByTagName("body")[0].innerText.split(/\\s+/); var totalPoints = 0; totalPoints += Math.min(hrefs.size * 3, 4); totalPoints += Math.min(imgs.size * 2, 3); totalPoints += Math.min(lists.length, 1); totalPoints += (text.length < 150 && text.length > 40) ? 3 : 0; var pointsString = totalPoints + " "; if (totalPoints >= 6) { pointsString += "💯"; } else if (totalPoints > 3) {pointsString += "🤔";} else {pointsString += "😐";} $("#\(divID)").find(".solution-rating").text(pointsString);
"""
    }

    static func extend(session: ExtendSessionTypes) -> String {
"""
function extendSession() {
    let url = "/api/\(session.rawValue)-sessions/" + sessionID() + "/extend"
    fetch(url, {
        method: "POST",
        headers: {
            "Accept": "application/json, text/plain, */*",
            "Content-Type" : "application/json"
        }
    })
    .then(function (response) {
        if (response.ok) {
            location.href = nextIndex;
        } else {
            throw new Error(response.statusText);
        }
    })
    .catch(function (error) {
        $("#submitButton").attr("disabled", false);
        $("#error-massage").text(error.message);
        $("#error-div").fadeIn();
        $("#error-div").removeClass("d-none");
    });
}
"""
    }
}

public struct TaskPreviewTemplate: HTMLComponent {

    let context: TemplateValue<TaskPreviewTemplateContext>
    let actionCard: HTML
    var underSolutionCard: HTML = ""
    private var overSolutionCard: HTML = ""
    var customScripts: HTML = ""
    let sessionType: ExtendSessionTypes

    init(context: TemplateValue<TaskPreviewTemplateContext>, sessionType: ExtendSessionTypes, @HTMLBuilder actionCard: () -> HTML) {
        self.context = context
        self.actionCard = actionCard()
        self.underSolutionCard = ""
        self.sessionType = sessionType
    }

    init(context: TemplateValue<TaskPreviewTemplateContext>, actionCard: HTML, overSolutionCard: HTML, underSolutionCard: HTML, customScripts: HTML, sessionType: ExtendSessionTypes) {
        self.context = context
        self.actionCard = actionCard
        self.overSolutionCard = overSolutionCard
        self.underSolutionCard = underSolutionCard
        self.customScripts = customScripts
        self.sessionType = sessionType
    }

    func underSolutionCard(@HTMLBuilder _ card: () -> HTML) -> TaskPreviewTemplate {
        TaskPreviewTemplate(context: context, actionCard: actionCard, overSolutionCard: overSolutionCard, underSolutionCard: card(), customScripts: customScripts, sessionType: sessionType)
    }

    func overSolutionCard(@HTMLBuilder _ card: () -> HTML) -> TaskPreviewTemplate {
        TaskPreviewTemplate(context: context, actionCard: actionCard, overSolutionCard: card(), underSolutionCard: underSolutionCard, customScripts: customScripts, sessionType: sessionType)
    }

    func scripts(@HTMLBuilder _ scripts: () -> HTML) -> TaskPreviewTemplate {
        TaskPreviewTemplate(context: context, actionCard: actionCard, overSolutionCard: overSolutionCard, underSolutionCard: underSolutionCard, customScripts: scripts(), sessionType: sessionType)
    }

    public var body: HTML {
        BaseTemplate(context: .init(
            title: "Oppgave",
            description: "Lær mer ved å øve",
            showCookieMessage: false
        )) {
            Container {
                PageTitle(title: Strings.exerciseMainTitle.localized() + " " + context.currentTaskIndex)

                PracticeSessionProgressBar(context: context)

                Input()
                    .type(.hidden)
                    .value(context.task.id)
                    .id("task-id")

                Row {
                    Div {
                        QuestionCard(
                            exam: context.task.exam,
                            description: context.taskContent.task.description,
                            question: context.taskContent.task.question
                        )
                        actionCard
                    }
                    .column(width: .seven, for: .large)

                    Div {
                        overSolutionCard
                        TaskSolutionCard(
                            fetchUrl: Script.fetchSolutionSessionUrl,
                            extraScripts: Script.practiceSessionIDFromUri + Script.practiceSessionTaskIndexFromUri
                        )
                        DismissableError()
                        underSolutionCard
//                        TaskDiscussionCard()
                    }
                    .column(width: .five, for: .large)
                }
                .id("main-task-content")

                Row {
                    Div { NavigationCard(context: context, sessionType: sessionType) }
                        .column(width: .twelve)
                }
                .class("fixed-bottom")
                .id("nav-card")

                Modal(title: "Bra jobba!", id: "goal-completed") {
                    Text { "Bra jobba! 💪" }
                        .style(.heading2)
                        .margin(.four, for: .bottom)

                    Text {
                        "Du har fullført "
                        context.numberOfTaskGoal
                        " oppgaver!"
                    }
                    .style(.heading4)

                    Text { "Vil du fortsette?" }.margin(.four, for: .bottom)

                    Button { "Gjør 5 oppgaver til" }
                        .button(style: .primary)
                        .on(click: context.extendSessionCall)

                    Button { "Avslutt" }
                        .button(style: .light)
                        .on(click: context.endSessionCall)
                        .margin(.two, for: .left)
                }
            }
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
            Script { Script.autoResizeTextAreas }
            Script { Script.extend(session: sessionType) }
            customScripts
        }
    }

    struct QuestionCard: HTMLComponent {

        let exam: TemplateValue<Exam.Compact?>
        let description: TemplateValue<String?>
        let question: TemplateValue<String>

        var body: HTML {
            Row {
                Div {
                    Card {
                        ExamBadge(exam: exam)
                        IF(description.isDefined) {
                            Text { description.escaping(.unsafeNone) }
                                .style(.paragraph)
                                .text(color: .secondary)
                                .margin(.two, for: .bottom)
                                .class("render-markdown")
                        }
                        Text { question }
                            .style(.heading4)
                            .class("render-markdown")
                    }
                    .display(.block)
                }
                .column(width: .twelve)
            }
        }
    }

    struct NavigationCard: HTMLComponent {

        let context: TemplateValue<TaskPreviewTemplateContext>
        let sessionType: ExtendSessionTypes

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
                            .float(.left)
                        }

                        Div {
                            Button(Strings.exerciseStopSessionButton)
                                .button(style: .danger)
                                .on(click: context.endSessionCall)
                        }
                        .text(alignment: .center)
                    }
                    .action("/\(sessionType.rawValue)-sessions/" + context.sessionID + "/end")
                    .method(.post)
                    .id("end-session-form")
                }
                .padding(.zero, for: .horizontal)
            }
            .margin(.zero, for: .bottom)
        }

        var scripts: HTML {
            NodeList {
                Script {
"""
function endSession() { $("#end-session-form").submit() }
"""
                }
                body.scripts
            }
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
                                Span { context.numberOfTaskGoal }
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

struct ExamBadge: HTMLComponent {

    let exam: TemplateValue<Exam.Compact?>

    var body: HTML {
        Unwrap(exam) { exam in
            Badge {
                "Oppgave på eksamen "
                exam.description
            }
            .background(color: .primary)
        }
    }
}

typealias StaticView = HTMLComponent
typealias TemplateView = HTMLTemplate
