
import BootstrapKit
import KognitaCore

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

            fileprivate let listContext: Subject.Templates.TaskList.Context
            let topics: [Topic]

            public init(user: User, subject: Subject, tasks: [CreatorTaskContent]) {
                self.user = user
                self.subject = subject
                self.totalNumberOfTasks = tasks.count
                self.listContext = .init(
                    userID: user.id ?? 0,
                    tasks: tasks
                )
                self.topics = tasks.group(by: \.topic.id)
                    .compactMap { id, tasks in tasks.first(where: { $0.topic.id == id })?.topic }
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
                                "Lag innskrivingsoppgave"
                            }
                            .href(context.subject.createFlashCardTaskUri)
                            .button(style: .success)
                            .margin(.two, for: .left)
                        }
                    }
                    .column(width: .twelve)
                }
                Row {
                    SearchCard(context: context)
                }
                Row {
                    Subject.Templates.TaskList(context: context.listContext)
                }.id("search-result")
            }
            .scripts {
                Script(source: "/assets/js/delete-task.js")
            }
        }
    }
}

extension Subject.Templates.ContentOverview.Context {
    var searchUrl: String {
        guard let subjectID = subject.id else {
            return ""
        }
        return "subjects/\(subjectID)/search"
    }
}

extension TopicTasks {
    var editUrl: String { "/creator/subjects/\(topic.subjectId)/topics/\(topic.id ?? 0)/edit" }
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
    var editUri: String { "/creator/\(taskTypePath)/\(task.id ?? 0)/edit" }
    var deleteCall: String { "deleteTask(\(task.id ?? 0), \"\(taskTypePath)\");" }
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
                    InputGroup {
                        Input()
                            .type(.text)
                            .placeholder("Søk..")
                            .id("taskQuestion")
                            .name("taskQuestion")
                    }
                    .append {
                        Button {
                            "Søk"
                        }
                        .button(style: .primary)
                        .type(.submit)
                    }
                    .margin(.three, for: .bottom)

                    Row {
                        ForEach(in: context.topics) { topic in
                            Div {
                                Div {
                                    Input()
                                        .type(.checkbox)
                                        .class("custom-control-input")
                                        .name("topics[]")
                                        .value(topic.id)
                                        .id(topic.id)
                                    Label {
                                        topic.name
                                    }
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
        function \(functionName)() {
          let query = $("#\(request.formID)").serializeArray().reduce(function (r, v) { return r + v.name + "=" + encodeURI(v.value) + "&"; }, "").slice(0, -1)
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
        """
        return NodeList {
            form.scripts
            Script { script }
        }
    }
}


extension SearchFetch: InputGroupAddons {}
