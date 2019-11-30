////
////  SubjectPracticeModal.swift
////  App
////
////  Created by Mats Mollestad on 27/02/2019.
////
//// swiftlint:disable line_length nesting
//
//import BootstrapKit
//import KognitaCore
//
//
//extension Subject.Templates {
//    struct PracticeModal<T>: HTMLComponent {
//
//        let topics: TemplateValue<T, [Topic.Response]>
//
//        var body: HTML {
//            Div {
//                Div {
//                    Div {
//                        Div {
//                            H4 {
//                                "localize(.startText)"
//                            }
//                            .class("modal-title")
//                            .id("practice-modal-label")
//
//                            Button {
//                                "×"
//                            }
//                            .type("button")
//                            .class("close")
//                            .data(for: "dismiss", value: "modal")
//                            .aria(for: "hidden", value: "true")
//                        }
//                        .class("modal-header bg-light")
//                        Div {
//                            Div {
//                                Div {
//                                    Label {
//                                        "localize(.workGoal)"
//                                    }
//                                    Input()
//                                        .id("task-number-input")
//                                        .value("5")
//                                        .data(for: "toggle", value: "touchspin")
//                                        .type(.text)
//                                        .data(for: "bts-prefix", value: "localize(.workGoalUnit)")
//                                }
//                                .class("form-group mb-3")
//
//                                Div {
//                                    P {
//                                        "localize(.topicsTitle)"
//                                    }
//                                    .class("mb-1 mt-3 font-weight-bold text-secondery")
//                                    P {
//                                        "localize(.topicsDescription)"
//                                    }
//                                    .class("text-muted font-14")
//                                    Select {
//                                        ForEach(in: topics) { (topic: RootValue<Topic.Response>) in
//                                            OptionGroup {
//                                                ForEach(in: topic.subtopics) { subtopic in
//                                                    Option {
//                                                        subtopic.name + " - " + topic.topic.name
//                                                    }
//                                                    .value(subtopic.id)
//                                                    .isSelected(true)
//                                                }
//                                            }
//                                            .label(topic.topic.name)
//                                        }
//                                    }
//                                    .id("practice-topic-selector")
//                                    .class("select2 form-control select2-multiple")
//                                    .data(for: "toggle", value: "select2")
//                                    .data(for: "placeholder", value: "localize(.topicsSelect)")
//                                    .isMultiple(true)
//                                }
//                                .class("tab-pane show")
//                                .id("select-topics")
//
//                                Div {
//                                    Button {
//                                        " " + "localize(.startText)"
//                                    }
//                                    .type("button")
//                                    .on(click: "startPracticeSession();")
//                                    .class("btn btn-primary btn-rounded mb-3")
//                                }
//                                .class("mt-4")
//                            }
//                            .class("p-2")
//                        }
//                        .class("modal-body")
//                    }
//                    .class("modal-content")
//                }
//                .class("modal-dialog modal-dialog-centered modal-lg")
//            }
//            .class("modal fade")
//            .id("start-practice-session")
////            .tabIndex(RootValue<Int>.constant(-1))
////            .tabindex("-1")
//            .role("dialog")
//            .aria(for: "labelledby", value: "practice-modal-label")
//            .aria(for: "hidden", value: "true")
//
//        }
//    }
//}
