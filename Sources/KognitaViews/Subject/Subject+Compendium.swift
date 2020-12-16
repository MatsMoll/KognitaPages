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
            }
            .header {
                Stylesheet(url: "/assets/css/vendor/katex.min.css")
            }
            .scripts {
                Script(source: "/assets/js/vendor/marked.min.js")
                Script(source: "/assets/js/vendor/katex.min.js")
                Script(source: "/assets/js/markdown-renderer.js")
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
            .margin(.four, for: .vertical)
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
        NodeList {
            Text { subtopic.name }
                .style(.heading3)
                .text(color: .dark)
                .margin(.three, for: .vertical)
                .id(subtopic.hrefID)

            ForEach(in: subtopic.questions) { question in
                QuestionSection(question: question)
            }

            PracticeCard(subtopic: subtopic)
        }
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
