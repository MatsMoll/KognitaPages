import BootstrapKit
import KognitaCore

extension Subject.Templates {

    public struct Compendium: HTMLTemplate {

        public struct Context {
            let user: User
            let compendium: Subject.Compendium

            public init(user: User, compendium: Subject.Compendium) {
                self.user = user
                self.compendium = compendium
            }
        }

        public var body: HTML {

            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Kompendie", description: ""))
            ) {
                PageTitle(title: "Kompendie")
                Row {
                    Div {
                        Card {
                            Div {
                                ForEach(in: context.compendium.topics) { topic in
                                    Anchor {
                                        topic.chapter
                                        ". "
                                        topic.name
                                    }
                                        .href("#" + topic.nameID)
                                        .class("list-group-item list-group-item-action")
                                }
                            }
                            .class("list-group")
                            .id("compendium-overview")
                        }
                    }
                    .column(width: .twelve)

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
                    .column(width: .twelve)
                }
            }
            .header {
                Link().href("https://cdn.jsdelivr.net/npm/katex@0.11.1/dist/katex.min.css").relationship(.stylesheet)
            }
            .scripts {
                Script(source: "https://cdn.jsdelivr.net/npm/marked/marked.min.js")
                Script(source: "https://cdn.jsdelivr.net/npm/katex@0.11.1/dist/katex.min.js")
                Script(source: "/assets/js/markdown-renderer.js")
            }
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

            ForEach(in: subtopic.questions) { question in
                QuestionSection(question: question)
            }
        }
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
