//
//  SubjectMappingTestModal.swift
//  App
//
//  Created by Mats Mollestad on 27/02/2019.
//
// swiftlint:disable line_length nesting

import HTMLKit
import KognitaCore

public struct SubjectMappingTestModal: LocalizedTemplate {

    public init() {}

    public static var localePath: KeyPath<Context, String>?

    public enum LocalizationKeys: String {
        case none
    }

    public struct Context {

        let topics: [ModalSelectOption.Context]

        init(topics: [Topic.Response]) {
            self.topics = topics.map { .init(topic: $0.topic, subtopics: $0.subtopics) }
        }
    }

    public func build() -> CompiledTemplate {
        return
            div .class("modal fade") .id("start-test-session") .tabindex("-1") .role("dialog") .ariaLabelledby("mapping-modal-label") .ariaHidden("true") .child(
                div .class("modal-dialog modal-dialog-centered modal-lg") .child(
                    div .class("modal-content") .child(
                        div .class("modal-header bg-light") .child(
                            h4.class("modal-title").id("mapping-modal-label").child(
                                "Start a test"
                            ),
                            button.type("button").class("close").dataDismiss("modal").ariaHidden("true").child("×")
                        ),
                        div.class("modal-body").child(
                            div.class("p-2").child(
                                h5.class("mt-0").child(
                                    "Beskrivelse:"
                                ),
                                p.class("text-muted mb-4").child(
                                    "Some info about how this will work. Voluptates, illo, iste itaque voluptas corrupti ratione reprehenderit magni similique? Tempore, quos delectus asperiores libero voluptas quod perferendis! Voluptate, quod illo rerum? Lorem ipsum dolor sit amet. With supporting text below as a natural lead-in to additional contenposuere erat a ante."
                                ),
                                div.class("mt-4").child(
                                    p.class("mb-1 mt-3 font-weight-bold text-secondery").child(
                                        "Velg temaer"
                                    ),
                                    p.class("text-muted font-14").child(
                                        "Velg de temaene du vil øve på"
                                    ),

                                    // Selector
                                    select.id("mapping-topic-selector").class("select2 form-control select2-multiple").dataToggle("select2").multiple.dataPlaceholder("Choose ...").child(
                                        optgroup.label("Hele temaer").child(
                                            forEach(
                                                in: \.topics,
                                                render: ModalSelectOption()
                                            )
                                        )
                                    )
                                ),
                                div.class("mt-4").child(
                                    button.type("button").onclick("startMappingSession()").class("btn btn-success btn-rounded mb-3").child(
                                        " Start test"
                                    )
                                )
                            )
                        )
                    )
                )
        )
    }



    struct ModalSelectOption: ContextualTemplate {

        struct Context {
            let topic: Topic
            let subtopics: [SubtopicOption.Context]

            init(topic: Topic, subtopics: [Subtopic]) {
                self.topic = topic
                self.subtopics = subtopics.map { .init(topic: topic, subtopic: $0) }
            }
        }

        func build() -> CompiledTemplate {
            return optgroup.label(variable(\.topic.name)).child(
                forEach(
                    in: \.subtopics,
                    render: SubtopicOption()
                )
            )
        }
    }

    struct SubtopicOption: ContextualTemplate {

        struct Context {
            let topic: Topic
            let subtopic: Subtopic
        }

        func build() -> CompiledTemplate {
            return option.selected.value(variable(\.subtopic.id)).child(
                variable(\.subtopic.name) + " - " + variable(\.topic.name)
            )
        }
    }
}
