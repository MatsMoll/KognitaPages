import BootstrapKit

extension Subject.Compendium {
    fileprivate var subjectUri: String { "/subjects/\(subjectID)" }
}

extension Subject.Compendium.TopicData {
    fileprivate var nameID: String { "topic-\(chapter)" }
}

extension Subject.Compendium.SubtopicData {
    fileprivate var hrefID: String { "subtopic-\(subtopicID)" }
}

extension Subject.Templates {

    /// Presenting an compendum for in a given subject
    public struct Compendium: HTMLTemplate {

        public struct Context {
            let user: User
            let compendium: Subject.Compendium

            public init(user: User, compendium: Subject.Compendium) {
                self.user = user
                self.compendium = compendium
            }
        }

        var breadcrumbItems: [BreadcrumbItem] {
            [
                BreadcrumbItem(link: "/subjects", title: "Fagoversikt"),
                BreadcrumbItem(link: ViewWrapper(view: context.compendium.subjectUri), title: ViewWrapper(view: context.compendium.subjectName))
            ]
        }

        public var body: HTML {

            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Kompendium", description: "", showCookieMessage: false))
            ) {
                PageTitle(title: "Kompendium", breadcrumbs: breadcrumbItems)
                Container {
                    Row {
                        Div {
                            TableOfContent(topics: context.compendium.topics)
                        }
                        .column(width: .four, for: .large)
                    }
                }
                .id("compendium-toc")
                .class("position-lg-fixed scrollable-toc")
                .padding(.zero)

                Row {
                    Div {
                        Card {
                            Text { context.compendium.subjectName }
                                .style(.heading1)
                                .text(color: .dark)
                                .margin(.four, for: .bottom)

                            ForEach(in: context.compendium.topics) { topic in
                                TopicSection(topic: topic)
                            }
                        }
                    }
                    .column(width: .eight, for: .large)
                    .offset(width: .four, for: .large)
                    .id("compendium-content")
                }
                
                TermDetail()
                TermCreateModal()
                ResourceCreateModal()
            }
            .header {
                Stylesheet(url: "/assets/css/vendor/katex.min.css")
                Stylesheet(url: "/assets/css/vendor/simplemde.min.css")
            }
            .scripts {
                Script(source: "/assets/js/vendor/marked.min.js")
                Script(source: "/assets/js/vendor/katex.min.js")
                Script(source: "/assets/js/markdown-renderer.js")
                Script(source: "/assets/js/vendor/simplemde.min.js")
                Script(source: "/assets/js/markdown-renderer.js")
                Script(source: "/assets/js/markdown-editor.js")
                
                Script(source: "/assets/js/practice-session-create.js")
                Script {
"""
$(document).scroll(function() {
let contentTop = $("#compendium-content").offset().top;
let contentHeight = $("#compendium-content").height();
let scrollTop = Math.min(Math.max($(document).scrollTop(), 0), $(document).height() - $(window).height());
let tocHeight = $("#compendium-toc").height();
let potensialTop = Math.max(contentTop - scrollTop, 40);
let newContentTop = Math.min(potensialTop, contentTop + contentHeight - scrollTop - tocHeight);
$("#compendium-toc").css("top", newContentTop);
})
"""
                }
            }
            .scrollSpy(targetID: "compendium-overview")
        }
    }
}

private struct TableOfContent: HTMLComponent {

    let topics: TemplateValue<[Subject.Compendium.TopicData]>

    var body: HTML {
        Card {
            Text { "Innholdsfortegnelse" }
                .style(.heading3)
                .text(color: .dark)
                .margin(.three, for: .bottom)
            Div {
                ForEach(in: topics) { (topic: TemplateValue<Subject.Compendium.TopicData>) in
                    Anchor {
                        topic.chapter
                        ". "
                        topic.name
                    }
                        .href("#" + topic.nameID)
                        .class("list-group-item list-group-item-action")

                    IF(topic.subtopics.count > 1) {
                        Div {
                            ForEach(in: topic.subtopics) { subtopic in
                                Subtopics(subtopic: subtopic)
                            }
                        }
                        .class("nav")
                        .padding(.three, for: .left)
                    }
                }
            }
            .class("list-group")
            .id("compendium-overview")
        }
    }

    struct Subtopics: HTMLComponent {

        let subtopic: TemplateValue<Subject.Compendium.SubtopicData>

        var body: HTML {
            Anchor { subtopic.name }
                .href("#" + subtopic.hrefID)
                .class("list-group-item list-group-item-action")
        }
    }
}

private struct TopicSection: HTMLComponent {

    let topic: TemplateValue<Subject.Compendium.TopicData>

    var body: HTML {
        NodeList {
            Text {
                topic.chapter
                ". "
                topic.name
            }
            .style(.heading2)
            .text(color: .dark)
            .margin(.four, for: .top)
            .id(topic.nameID)

            ForEach(in: topic.subtopics) { subtopic in
                SubtopicSection(subtopic: subtopic)
            }
        }
    }
}

private struct SubtopicSection: HTMLComponent {

    let subtopic: TemplateValue<Subject.Compendium.SubtopicData>

    var body: HTML {
        Div {
            
            Text {
                "Begreper innen "
                subtopic.name
            }
            .style(.heading3)
            .text(color: .dark)
            
            Row {
                ForEach(in: subtopic.terms) { term in
                    Div {
                        TermCard(term: term)
                    }
                    .column(width: .six, for: .large)
                }
                
                Div {
                    Card {
                        Text { "Vil du legge til et nytt begrep?" }
                            .style(.lead)
                        
                        TermCreateModal.button(subtopicID: subtopic.subtopicID)
                    }
                    .class("border border-light")
                }
                .column(width: .six, for: .large)
            }
            
            
            Text { subtopic.name }
                .style(.heading3)
                .text(color: .dark)
                .margin(.three, for: .vertical)

            ForEach(in: subtopic.questions) { question in
                QuestionSection(question: question)
            }

//            PracticeCard(subtopic: subtopic)
        }
        .id(subtopic.hrefID)
        .padding(.four, for: .top)
    }
}

struct TermCard: HTMLComponent {
    
    let term: TemplateValue<Term.Compact>
    
    var body: HTML {
        Card {
            Anchor {
                Text {
                    term.term
                    MaterialDesignIcon(.arrowRight)
                        .margin(.one, for: .left)
                }
                .style(.heading4)
                .text(color: .dark)
            }
            .toggle(modal: .id("term-detail"))
            .data("meaning", value: term.meaning)
            .data("term", value: term.term)
            .data("id", value: term.id)
        }
        .class("border border-light")
    }
}

struct TermDetail: HTMLComponent {
    
    var body: HTML {
        Modal(title: "Detail", id: "term-detail") {
            
            Button {
                "Slett"
                MaterialDesignIcon(.delete)
            }
            .on(click: "deleteTerm()")
            .button(style: .danger)
            .float(.right)
            
            Text { "" }
                .style(.heading2)
                .id("term-title")
                .text(color: .dark)
            
            Text { "" }
                .style(.lead)
                .id("term-meaning")
                .margin(.three, for: .top)
                .text(color: .dark)
                .class("render-markdown")
            
            Text { "Les mer via" }
                .style(.heading5)
                .margin(.three, for: .top)
            
            Input().type(.hidden).id("term-id")
            
            // Update on load
            Div().id("term-resources")
            
            ResourceCreateModal
                .button(connectionType: .term, connectionID: "")
                .dismissModal()
                .id("term-resource-btn")
        }
        .set(data: "term", type: .node, to: "term-title")
        .set(data: "id", type: .input, to: "term-id")
    }
    
    var scripts: HTML {
        NodeList {
            body.scripts
            Script {
                """
                $('#term-detail').on('show.bs.modal', function (event) {
                  let button = $(event.relatedTarget);
                  let id = button.data('id');
                  fetchResources(id)
                  fetchTerm(id)
                  document.getElementById("term-resource-btn").setAttribute("data-con-id", id);
                })
                """
            }
            Script(source: "/assets/js/resources/fetch-html.js")
            Script(source: "/assets/js/term/delete.js")
        }
    }
}

public struct TermCreateModal: HTMLComponent {
    
    static func button(subtopicID: HTML) -> Button {
        Button {
            MaterialDesignIcon(.fileDocument)
                .margin(.one, for: .right)
            "Lag begrep"
        }
        .button(style: .light)
        .toggle(modal: .id(TermCreateModal.modalID))
        .data("subtopic-id", value: subtopicID)
    }
    
    static let modalID = "create-term"
    
    public var body: HTML {
        Modal(title: "Lag et begrep", id: TermCreateModal.modalID) {
            FormGroup(label: "Begrep") {
                Input().type(.text).id("new-term")
                    .placeholder("SQL, Logical address")
            }
            
            Label { "Definisjon" }.for("new-term-meaning")
            MarkdownEditor(id: "new-term-meaning")
                .placeholder("En eller annen definisjon")
            
            Input().type(.hidden).id("new-term-subtopic-id")
            
            Button {
                "Lagre"
                MaterialDesignIcon(.check)
                    .margin(.one, for: .left)
            }
            .button(style: .success)
            .on(click: "createTerm()")
        }
        .set(data: "subtopic-id", type: .input, to: "new-term-subtopic-id")
    }
    
    public var scripts: HTML {
        NodeList {
            body.scripts
            Script(source: "/assets/js/term/create.js")
        }
    }
}

struct Tabs: HTMLComponent {
    
    struct Header {
        let smallIcon: MaterialDesignIcon.Icons
        let largeLabel: HTML
        let id: String
    }
    
    struct Definition {
        let header: Header
        let body: HTML
    }
    
    let content: [Definition]
    let selectedID: String
    
    init() {
        self.content = []
        self.selectedID = ""
    }
    
    private init(content: [Definition], selectedID: String) {
        self.content = content
        self.selectedID = selectedID
    }
    
    var body: HTML {
        NodeList {
            UnorderedList {
                content.map { (tab) -> HTML in
                    ListItem {
                        Anchor {
                            MaterialDesignIcon(tab.header.smallIcon)
                                .display(.none, breakpoint: .medium)
                                .display(.block)
                            
                            Span { tab.header.largeLabel }
                                .display(.block, breakpoint: .medium)
                                .display(.none)
                        }
                        .href("#\(tab.header.id)")
                        .class("nav-link\(tab.header.id == selectedID ? " active" : "")")
                        .data("toggle", value: "tab")
                        .aria("expanded", value: tab.header.id == selectedID)
                    }
                    .class("nav-item")
                }
            }
            .class("nav nav-tabs nav-bordered nav-justified mb-3")
            
            Div {
                content.map { (tab) -> HTML in
                    Div {
                        tab.body
                    }
                    .id(tab.header.id)
                    .class("tab-pane\(tab.header.id == selectedID ? " show active" : "")")
                }
            }
            .class("tab-content")
        }
    }
    
    
    func add(tabID: String, icon: MaterialDesignIcon.Icons, label: HTML, @HTMLBuilder body: () -> HTML) -> Self {
        .init(content: content + [Definition(header: .init(smallIcon: icon, largeLabel: label, id: tabID), body: body())], selectedID: selectedID)
    }
    
    func selected(id: String) -> Self {
        .init(content: content, selectedID: id)
    }
}

extension Subject.Compendium.SubtopicData {
    fileprivate var startPracticeSessionCall: String { "startPracticeSessionWithSubtopicIDs([\(subtopicID)], \(subjectID));" }
}

private struct PracticeCard: HTMLComponent {

    let subtopic: TemplateValue<Subject.Compendium.SubtopicData>

    var body: HTML {
        Card {
            Text { "Sjekk hvor mye du husker" }
                .style(.heading3)

            Text { "Ved å ta en test vil stoffet sitte bedre ifølge kognitiv forskning." }

            Button {
                MaterialDesignIcon(icon: .testTube)
                    .margin(.one, for: .right)
                "Test deg selv"
            }
            .button(style: .light)
            .on(click: subtopic.startPracticeSessionCall)
            .margin(.two, for: .top)
            .isRounded()
        }
        .background(color: .primary)
        .text(color: .white)
    }
}

private struct QuestionSection: HTMLComponent {

    let question: TemplateValue<Subject.Compendium.QuestionData>

    var body: HTML {
        NodeList {
            Text { question.question }
                .style(.heading4)
                .class("render-markdown")

            Div { question.solution.renderMarkdown() }
                .margin(.four, for: .bottom)
                .margin(.three, for: .left)
        }
    }
}

struct MarkdownRendering: HTMLComponent {

    let value: TemplateValue<String>

    var body: HTML {
        Div {
            value.escaping(.unsafeNone)
        }.class("render-markdown")
    }
}

extension TemplateValue where Value == String {
    func renderMarkdown() -> MarkdownRendering { MarkdownRendering(value: self) }
}
