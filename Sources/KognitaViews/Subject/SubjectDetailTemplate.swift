//
//  SubjectDetailTemplate.swift
//  App
//
//  Created by Mats Mollestad on 26/02/2019.
//
// swiftlint:disable line_length nesting

import HTMLKit
import KognitaCore

extension AttributableNode {

    func dataToggle(_ value: CompiledTemplate...) -> Self {
        return add(.init(attribute: "data-toggle", value: value))
    }

    func dataTarget(_ value: CompiledTemplate...) -> Self {
        return add(.init(attribute: "data-target", value: value))
    }

    func dataPlaceholder(_ value: CompiledTemplate...) -> Self {
        return add(.init(attribute: "dataPlaceholder", value: value))
    }
}

public struct SubjectDetailTemplate: LocalizedTemplate {

    public init() {}

    public static var localePath: KeyPath<SubjectDetailTemplate.Context, String>? = \.locale

    public enum LocalizationKeys: String {
        case subjectsTitle = "subjects.title"
        case startSession = "subject.session.start"
        case topicListTitle = "subject.topics.title"
        case noTopics = "subject.topics.none"
    }

    public struct Context {
        let locale = "nb"
        let base: ContentBaseTemplate.Context
        let subjectContext: SubjectDetailCard.Context
        var subject: Subject { return subjectContext.subject }
        let topics: [Topic]
        let topicsLevels: [TopicCard.Context]

        public init(user: User, subject: Subject, topics: [Topic], levels: [UserLevel], subjectLevel: UserSubjectLevel) {
            self.base = .init(user: user, title: subject.name)
            self.subjectContext = .init(subject: subject, level: subjectLevel)
            self.topics = topics
            self.topicsLevels = topics.map { topic in
                return .init(topic: topic, level: levels.first(where: { $0.topicID == topic.id }))
            }
        }
    }

    public func build() -> CompiledTemplate {
        return embed(
            ContentBaseTemplate(
                body:
                div.class("row").child(
                    div.class("col-12").child(
                        div.class("page-title-box").child(
                            div.class("page-title-right").child(
                                ol.class("breadcrumb m-0").child(
                                    li.class("breadcrumb-item").child(
                                        a.href("../subjects").child(
                                            localize(.subjectsTitle)
                                        )
                                    ),
                                    li.class("breadcrumb-item active").child(
                                        variable(\.subject.name)
                                    )
                                )
                            ),
                            h4.class("page-title").child(
                                variable(\.subject.name)
                            )
                        )
                    )
                ),

                div.class("row mb-2").child(
                    div.class("col-sm-6").child(

//                        // Start mapping test
//                        a.dataToggle("modal").dataTarget("#start-test-session").child(
//                            button.type("button").class("btn btn-success btn-rounded mb-3 mr-1").child(
//                                i.class("mdi mdi-trophy"),
//                                " Start en test"
//                            )
//                        ),

                        // Start practice session
                        a.dataToggle("modal").dataTarget("#start-practice-session").child(

                            button.type("button").class("btn btn-primary btn-rounded mb-3").child(
                                i.class("mdi mdi-book-open-variant"),
                                " " + localize(.startSession)
                            )
                        )
                    )
                ),
                div.class("row").child(
                    div.class("col-md-12").child(

                        embed(
                            SubjectDetailCard(),
                            withPath: \.subjectContext
                        )
                    )
                ),

                div.class("row").child(
                    div.class("col-12").child(
                        div.class("page-title-box").child(
                            h4.class("page-title").child(
                                localize(.topicListTitle)
                            )
                        )
                    )
                ),

                // Topic List information
                div.class("row").child(
                    renderIf(
                        \.topics.count > 0,

                        forEach(
                            in:     \.topicsLevels,
                            render: TopicCard()
                        )
                    ).else (
                        div.class("page-title-box").child(
                            h3.class("page-title").child(
                                localize(.noTopics)
                            )
                        )
                    )
                ),

                scripts: [
//                    script.src("/assets/js/mapping-session-create.js"),
                    script.src("/assets/js/practice-session-create.js")
                ],

                modals: [
//                    embed(SubjectMappingTestModal(), withPath: \.topics),
                    embed(SubjectPracticeModal(), withPath: \.topics)
                ]
            ),
            withPath: \Context.base)
    }

    // MARK: - Subviews

    struct SubjectDetailCard: ContextualTemplate {

        struct Context {
            let subject: Subject
            let level: UserSubjectLevel
        }

        func build() -> CompiledTemplate {
            return
                div.class("card d-block").child(
                    div.class("card-body").child(

                        h2.class("mt-0 text-dark").child(
                            variable(\.subject.name)
                        ),
                        p.class("text-muted font-13 mb-3").child(
                            variable(\.subject.description, escaping: .unsafeNone)
                        )
                    ),

                    ul.class("list-group list-group-flush").child(
                        li.class("list-group-item p-3").child(
                            h5.class("card-title mb-3").child(
                                //                                    localize(.progressTitle)
                                "Totalt fullførte oppgaver"
                            ),
                            p.class("mb-2 font-weight-bold").child(
                                variable(\.level.correctScoreInteger),
                                span.class("float-right").child(
                                    variable(\.level.correctProsentage) + "%"
                                )
                            ),
                            div.class("progress progress-md").child(
                                div.class("progress-bar")
                                    .role("progressbar")
                                    .ariaValuenow(variable(\.level.correctProsentage))
                                    .ariaValuemin(0)
                                    .ariaValuemax(variable(\.level.maxScore))
                                    .style("width: " + variable(\.level.correctProsentage) + "%;")
                                    .if(\.level.correctProsentage < 50, add: .class("bg-danger"))
                                    .if(\.level.correctProsentage >= 50 && \.level.correctProsentage < 75, add: .class("bg-warning"))
                                    .if(\.level.correctProsentage >= 75, add: .class("bg-success"))
                            )
                        )
                    )
            )
        }
    }

    struct TopicCard: LocalizedTemplate {

        static var localePath: KeyPath<SubjectDetailTemplate.TopicCard.Context, String>?

        enum LocalizationKeys: String {
            case button = "subject.topic.card.button"
            case progressTitle = "subject.topic.card.progress.title"
        }

        struct Context {
            let topic: Topic
            let level: UserLevel?
        }

        func build() -> CompiledTemplate {

//            let url: [CompiledTemplate] = ["/topics/", variable(\.topic.id), "/tasks/multiple-choise"]

            return
                div.class("col-md-6 col-lg-4").child(
                    div.class("card d-block").child(
                        div.class("card-body").child(

                            // Title
                            h3.class("mt-0").child(
                                a.href("/topics/" + variable(\.topic.id)).class("text-dark").child(
                                    variable(\.topic.chapter) + ". " + variable(\.topic.name)
                                )
                            ),

                            a.href("/topics/" + variable(\.topic.id)).child(

                                button.type("button").class("btn btn-light btn-rounded mb-3").child(
                                    i.class("mdi mdi-book-open-variant"),
                                    " " + localize(.button)
                                )
                            )
                        ),

                        renderIf(
                            isNotNil: \.level,

                            ul.class("list-group list-group-flush").child(
                                li.class("list-group-item p-3").child(
                                    h5.class("card-title mb-3").child(
                                        localize(.progressTitle)
                                    ),
                                    p.class("mb-2 font-weight-bold").child(
                                        variable(\.level?.correctScoreInteger),
                                        span.class("float-right").child(
                                            variable(\.level?.correctProsentage) + "%"
                                        )
                                    ),
                                    div.class("progress progress-md").child(
                                        div.class("progress-bar")
                                            .role("progressbar")
                                            .ariaValuenow(variable(\.level?.correctProsentage))
                                            .ariaValuemin(0)
                                            .ariaValuemax(variable(\.level?.maxScore))
                                            .style("width: " + variable(\.level?.correctProsentage) + "%;")
                                            .if(\.level?.correctProsentage < 50, add: .class("bg-danger"))
                                            .if(\.level?.correctProsentage >= 50 && \.level?.correctProsentage < 75, add: .class("bg-warning"))
                                            .if(\.level?.correctProsentage >= 75, add: .class("bg-success"))
                                    )
                                )
                            )
                        )
                    )
            )
        }
    }

}
