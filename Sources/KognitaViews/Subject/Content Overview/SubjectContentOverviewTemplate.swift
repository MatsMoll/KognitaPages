import BootstrapKit

protocol DropdownItemable: AddableAttributeNode {}

extension Button: DropdownItemable {}
extension Anchor: DropdownItemable {}
extension FormGroup: DropdownItemable {}
extension InputGroup: DropdownItemable {}
extension FormCheck: DropdownItemable {}

@_functionBuilder
class DropdownBuilder {

    static func buildBlock(_ children: DropdownItemable...) -> HTML {
        return children.map { $0.add(.init(attribute: "class", value: "dropdown-item"), withSpace: true) }
    }
}

public struct Dropdown: HTMLComponent, AttributeNode {

    public var attributes: [HTMLAttribute]
    let title: HTML
    let content: HTML

    init(title: HTML, @DropdownBuilder content: () -> HTML) {
        self.title = title
        self.content = content()
        self.attributes = []
    }

    private init(title: HTML, content: HTML, attributes: [HTMLAttribute]) {
        self.title = title
        self.content = content
        self.attributes = attributes
    }

    public var body: HTML {
        let id = value(of: "id") ?? "dropdown"
        let attributes = self.attributes.filter({ $0.attribute != "id" })

        return Div {
            Button {
                title
            }
            .data("haspopup", value: true)
            .data("expanded", value: false)
            .data("toggle", value: "dropdown")
            .button(style: .primary)
            .class("dropdown-toggle")

            Div { content }.class("dropdown-menu")
        }
        .add(attributes: attributes)
        .id(id)
    }

    public func copy(with attributes: [HTMLAttribute]) -> Dropdown {
        .init(title: title, content: content, attributes: attributes)
    }
}

private struct TopicTasks {
    let topic: Topic
    let tasks: [CreatorTaskContent]
}

extension Subject {
    var createMultipleTaskUri: String { "/creator/subjects/\(id)/task/multiple/create" }
    var createFlashCardTaskUri: String { "/creator/subjects/\(id)/task/flash-card/create" }
    var createTopicUri: String { "/subjects/\(id)/topics" }
    var createDraftUri: String { "/subjects/\(id)/tasks/draft" }
}

extension Subject.Templates {
    public struct ContentOverview: HTMLTemplate {

        public struct Context {
            let user: User
            let subject: Subject
            let totalNumberOfTasks: Int
            let isModerator: Bool
            let solutions: [TaskSolution.Unverified]

            fileprivate let listContext: Subject.Templates.TaskList.Context
            let topics: [Topic]

            public init(user: User, subject: Subject, tasks: [CreatorTaskContent], isModerator: Bool, solutions: [TaskSolution.Unverified]) {
                self.user = user
                self.subject = subject
                self.totalNumberOfTasks = tasks.count
                self.listContext = .init(
                    userID: user.id,
                    isModerator: isModerator,
                    tasks: tasks
                )
                self.topics = tasks.group(by: \.topic.id)
                    .compactMap { id, tasks in tasks.first(where: { $0.topic.id == id })?.topic }
                self.isModerator = isModerator
                self.solutions = solutions
            }
        }

        var breadcrumbs: [BreadcrumbItem] {
            [
                BreadcrumbItem(link: "/subjects", title: "Fagoversikt"),
                BreadcrumbItem(link: ViewWrapper(view: "/subjects/" + context.subject.id), title: ViewWrapper(view: context.subject.name))
            ]
        }

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(
                    title: "Innholdsoversikt",
                    description: "Innholdsoversikt",
                    showCookieMessage: false
                ))
            ) {
                PageTitle(title: "Innholdsoversikt", breadcrumbs: breadcrumbs)
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
                                "Lag notat "
                                MaterialDesignIcon(.note)
                            }
                            .href(context.subject.createDraftUri)
                            .button(style: .info)
                            .margin(.one, for: .bottom)

                            Break()
                                .display(.none, breakpoint: .large)

                            Anchor {
                                "Lag flervalgsoppgave "
                                MaterialDesignIcon(.formatListBulleted)
                            }
                            .href(context.subject.createMultipleTaskUri)
                            .button(style: .success)
                            .margin(.two, for: .left, sizeClass: .large)
                            .margin(.one, for: .bottom)

                            Break()
                                .display(.none, breakpoint: .medium)
                                .margin(.one, for: .bottom)

                            Anchor {
                                "Lag innskrivingsoppgave "
                                MaterialDesignIcon(.messageReplyText)
                            }
                            .href(context.subject.createFlashCardTaskUri)
                            .button(style: .success)
                            .margin(.two, for: .left, sizeClass: .medium)
                            .margin(.one, for: .bottom)

                            IF(context.isModerator) {

                                Break()
                                    .display(.none, breakpoint: .large)

                                Anchor { "Rediger temaer" }
                                    .href(context.subject.createTopicUri)
                                    .button(style: .primary)
                                    .margin(.two, for: .left, sizeClass: .large)
                                    .margin(.one, for: .bottom)
                            }

//                            QTIImportButton()
                        }
                    }
                    .column(width: .twelve)
                }
                Row {
                    UnverifiedSolutionsSection(solutions: context.solutions)
                }
                Row {
                    SearchCard(context: context)
                }
                Row {
                    Subject.Templates.TaskList(context: context.listContext)
                }.id("search-result")

                Stylesheet(url: "/assets/css/vendor/katex.min.css")
            }
            .scripts {
                Script(source: "/assets/js/delete-task.js")
            }
        }
    }
}

extension Array where Element == TaskSolution.Unverified {
    fileprivate var accordianTitle: String {
        "Godkjenn løsningsforslag (\(count))"
    }
}

private struct UnverifiedSolutionsSection: HTMLComponent {

    let solutions: TemplateValue<[TaskSolution.Unverified]>

    var body: HTML {
        IF(solutions.isEmpty == false) {
            Div {
                Accordion(title: solutions.accordianTitle) {
                    TaskSolution.Templates
                        .UnverifiedList(solutions: solutions)
                }
            }
            .column(width: .twelve)
        }
    }
}

extension Subject.Templates.ContentOverview.Context {
    var searchUrl: String {
        return "subjects/\(subject.id)/search"
    }
}

extension TopicTasks {
    var editUrl: String { "/creator/subjects/\(topic.subjectID)/topics/\(topic.id)/edit" }
}

//private struct TopicCard: HTMLComponent {
//
//    let topicTasks: TemplateValue<TopicTasks>
//
//    var body: HTML {
//        CollapsingCard {
//            Text {
//                topicTasks.topic.name
//            }
//            .style(.heading3)
//            .text(color: .dark)
//
//            Text {
//                topicTasks.tasks.count
//                " oppgaver"
//            }
//            .text(color: .secondary)
//        }
//        .content {
//            Div {
//                ForEach(in: topicTasks.tasks) { task in
//                    TaskCell(
//                        task: task
//                    )
//                }
//            }
//            .class("list-group list-group-flush")
//        }
//        .collapseId("collapse" + topicTasks.topic.id)
//    }
//}

extension CreatorTaskContent {
    var editUri: String { "/creator/\(taskTypePath)/\(task.id)/edit" }
    var deleteCall: String { "deleteTask(\(task.id), \"\(taskTypePath)\");" }
}

struct FormCheck: HTMLComponent, AttributeNode {

    public var attributes: [HTMLAttribute] = []
    let label: Label
    let input: FormInput

    public init(label: HTML, input: () -> FormInput) {
        self.label = Label { label }
        self.input = input()
    }

    private init(label: Label, input: FormInput, attributes: [HTMLAttribute]) {
        self.label = label
        self.input = input
        self.attributes = attributes
    }

    public var body: HTML {
        guard let inputId = input.value(of: "id") else {
            fatalError("Missing an id attribute on an Input in a FormGroup")
        }
        var inputNode = input
        if input.value(of: "name") == nil {
            inputNode = input.add(.init(attribute: "name", value: inputId), withSpace: false)
        }
        return Div {
            Div {
                inputNode.class("form-check-input")
            }
            .class("form-check")
            label.for(inputId).class("form-check-label")
        }
        .class("form-group")
        .add(attributes: attributes)
    }

    func copy(with attributes: [HTMLAttribute]) -> FormCheck {
        .init(label: label, input: input, attributes: attributes)
    }
}

struct SearchCard: HTMLComponent {

    let context: TemplateValue<Subject.Templates.ContentOverview.Context>

    var body: HTML {
        Div {
            Card {
                Form {
                    Label { "Søk i innholdet" }
                        .for("taskQuestion")
                    InputGroup {
                        Input()
                            .type(.text)
                            .placeholder("Søk..")
                            .id("taskQuestion")
                            .name("taskQuestion")
                    }
                    .append {
                        Button { "Søk" }
                            .button(style: .primary)
                            .type(.submit)
                    }
                    .margin(.three, for: .bottom)

                    Row {
                        Div {
                            Text { "Filterer på tema" }
                                .style(.heading4)
                        }
                        .column(width: .twelve)
                    }

                    Row {

                        ForEach(in: context.topics) { (topic: TemplateValue<Topic>) in
                            Div {
                                Div {
                                    Input()
                                        .type(.checkbox)
                                        .class("custom-control-input")
                                        .name("topics[]")
                                        .value(topic.id)
                                        .id(topic.id)
                                    Label { topic.name }
                                        .class("custom-control-label")
                                        .for(topic.id)
                                }
                                .class("custom-control custom-checkbox")
                            }
                            .column(width: .four, for: .large)
                            .column(width: .six, for: .medium)
                        }
                    }
                }
                .id("task-search-form")
                .fetch(url: "search", queryFormID: "task-search-form", resultTagID: "search-result")
            }
        }
        .column(width: .twelve)
    }
}

extension Form {
    func fetch(url: String, queryFormID formID: String, resultTagID: String) -> SearchFetch {
        SearchFetch(request: .init(url: url, formID: formID, resultID: resultTagID), form: self)
    }
}

struct SearchFetch: HTMLComponent {

    struct Request {
        let url: String
        let formID: String
        let resultID: String
    }

    let request: Request
    let form: Form

    var body: HTML {
        form.add(HTMLAttribute(attribute: "onsubmit", value: "\(functionName)(); return false;"))
    }

    var functionName: String { request.url.replacingOccurrences(of: "/", with: "") }

    var scripts: HTML {
        let script =
        """
        var lastFetch = new Date();
        function \(functionName)() {
          if (Math.abs(lastFetch - new Date()) < 100) { return; }
          lastFetch = new Date(); let query = $("#\(request.formID)").serializeArray().reduce(function (r, v) { return r + v.name + "=" + encodeURI(v.value) + "&"; }, "").slice(0, -1)
          fetch("\(request.url)?" + query, {
              method: "GET",
              headers: {
                  "Accept": "application/html, text/plain, */*",
              }
          })
          .then(function (response) {
              if (response.ok) {
                  return response.text();
              } else {
                  throw new Error(response.statusText);
              }
          })
          .then(function (html) {
            $("#\(request.resultID)").html(html);
          });
        }
        $(document).ready(function () { $('#\(request.formID) input[type=checkbox]').change(function () { \(functionName)() }); });
        """
        return NodeList {
//            form.scripts
            Script { script }
        }
    }
}
