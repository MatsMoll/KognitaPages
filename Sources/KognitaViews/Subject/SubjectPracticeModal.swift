//
//  SubjectPracticeModal.swift
//  App
//
//  Created by Mats Mollestad on 27/02/2019.
//
// swiftlint:disable line_length nesting

import BootstrapKit
import KognitaCore

//extension AttributableNode {
//
//    func dataBtsPrefix(_ value: CompiledTemplate) -> Self {
//        return add(.init(attribute: "data-bts-prefix", value: value))
//    }
//}

extension Subject.Templates {
    struct PracticeModal<T>: StaticView {

        let topics: TemplateValue<T, [Topic.Response]>

        var body: View {
            Div {
                Div {
                    Div {
                        Div {
                            H4 {
                                "localize(.startText)"
                            }
                            .class("modal-title")
                            .id("practice-modal-label")

                            Button {
                                "×"
                            }
                            .type("button")
                            .class("close")
                            .data(for: "dismiss", value: "modal")
                            .aria(for: "hidden", value: "true")
                        }
                        .class("modal-header bg-light")
                        Div {
                            Div {
                                Div {
                                    Label {
                                        "localize(.workGoal)"
                                    }
                                    Input()
                                        .id("task-number-input")
                                        .value("5")
                                        .data(for: "toggle", value: "touchspin")
                                        .type(.text)
                                        .data(for: "bts-prefix", value: "localize(.workGoalUnit)")
                                }
                                .class("form-group mb-3")

                                Div {
                                    P {
                                        "localize(.topicsTitle)"
                                    }
                                    .class("mb-1 mt-3 font-weight-bold text-secondery")
                                    P {
                                        "localize(.topicsDescription)"
                                    }
                                    .class("text-muted font-14")
                                    Select {
                                        ForEach(in: topics) { (topic: RootValue<Topic.Response>) in
                                            OptionGroup {
                                                ForEach(in: topic.subtopics) { subtopic in
                                                    Option {
                                                        subtopic.name + " - " + topic.topic.name
                                                    }
                                                    .value(subtopic.id)
                                                    .isSelected(true)
                                                }
                                            }
                                            .label(topic.topic.name)
                                        }
                                    }
                                    .id("practice-topic-selector")
                                    .class("select2 form-control select2-multiple")
                                    .data(for: "toggle", value: "select2")
                                    .data(for: "placeholder", value: "localize(.topicsSelect)")
                                    .isMultiple(true)
                                }
                                .class("tab-pane show")
                                .id("select-topics")

                                Div {
                                    Button {
                                        " " + "localize(.startText)"
                                    }
                                    .type("button")
                                    .on(click: "startPracticeSession();")
                                    .class("btn btn-primary btn-rounded mb-3")
                                }
                                .class("mt-4")
                            }
                            .class("p-2")
                        }
                        .class("modal-body")
                    }
                    .class("modal-content")
                }
                .class("modal-dialog modal-dialog-centered modal-lg")
            }
            .class("modal fade")
            .id("start-practice-session")
//            .tabIndex(RootValue<Int>.constant(-1))
//            .tabindex("-1")
            .role("dialog")
            .aria(for: "labelledby", value: "practice-modal-label")
            .aria(for: "hidden", value: "true")

        }
    }
}

//public struct SubjectPracticeModal: LocalizedTemplate {
//
//    public init() {}
//
//    public static var localePath: KeyPath<Context, String>?
//
//    public enum LocalizationKeys: String {
//        case startText = "subject.session.start"
//        case workGoal = "subject.session.work.goal"
//        case workGoalUnit = "subject.session.work.goal.unit"
//        case topicsTitle = "subject.session.topics.title"
//        case topicsDescription = "subject.session.topics.description"
//        case topicsSelect = "subject.session.topics.select"
//    }
//
//    public struct Context {
//
//        let topics: [SubjectMappingTestModal.ModalSelectOption.Context]
//
//        init(topics: [Topic.Response]) {
//            self.topics = topics.map { .init(topic: $0.topic, subtopics: $0.subtopics) }
//        }
//    }
//
//    public func build() -> CompiledTemplate {
//        return
//            div.class("modal fade").id("start-practice-session").tabindex("-1").role("dialog").ariaLabelledby("practice-modal-label").ariaHidden("true").child(
//                div.class("modal-dialog modal-dialog-centered modal-lg").child(
//                    div.class("modal-content").child(
//                        div.class("modal-header bg-light").child(
//                            h4.class("modal-title").id("practice-modal-label").child(
//                                localize(.startText)
//                            ),
//                            button.type("button").class("close").dataDismiss("modal").ariaHidden("true").child(
//                                "×"
//                            )
//                        ),
//                        div.class("modal-body").child(
//                            div.class("p-2").child(
//
//                                div.class("form-group mb-3").child(
//                                    label.child(
//                                        localize(.workGoal)
//                                    ),
//                                    input.id("task-number-input")
//                                        .value("5")
//                                        .dataToggle("touchspin")
//                                        .type("text")
//                                        .dataBtsPrefix(localize(.workGoalUnit))
//                                ),
//
//                                div.class("tab-pane show").id("select-topics").child(
//                                    p.class("mb-1 mt-3 font-weight-bold text-secondery").child(
//                                        localize(.topicsTitle)
//                                    ),
//                                    p.class("text-muted font-14").child(
//                                        localize(.topicsDescription)
//                                    ),
//
//                                    // Select
//                                    select.id("practice-topic-selector").class("select2 form-control select2-multiple").dataToggle("select2").multiple.dataPlaceholder(localize(.topicsSelect)).child(
//                                        optgroup.label("Hele temaer").child(
//                                            forEach(
//                                                in: \.topics,
//                                                render: SubjectMappingTestModal.ModalSelectOption()
//                                            )
//                                        )
//                                    )
//                                ),
//
//                                div.class("mt-4").child(
//                                    button.type("button").onclick("startPracticeSession();").class("btn btn-primary btn-rounded mb-3").child(
//                                        " " + localize(.startText)
//                                    )
//                                )
//                            )
//                        )
//                    )
//                )
//        )
//    }
//}
