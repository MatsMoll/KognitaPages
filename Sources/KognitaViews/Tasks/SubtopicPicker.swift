//
//  SubtopicPicker.swift
//  KognitaViews
//
//  Created by Mats Mollestad on 26/08/2019.
//

import HTMLKit
import KognitaCore

struct SubtopicPicker : ContextualTemplate {

    struct Context {
        let topics: [TopicSelect.Context]

        init(topics: [Topic.Response], selectedSubtopicId: Subtopic.ID?) {
            self.topics = ([Topic.Response.unselected] + topics)
                .map { .init(topicResponse: $0, selectedId: selectedSubtopicId) }
                .sorted(by: { (first, _) in first.isSelected })
        }
    }

    let idPrefix: String

    func build() -> CompiledTemplate {
        return [
            label.for(idPrefix + "topic-id").class("col-form-label").child(
                "Tema"
            ),
            select.id(idPrefix + "topic-id").class("select2 form-control select2").dataToggle("select2").dataPlaceholder("Velg ...").required.child(

                forEach(
                    in:     \.topics,
                    render: TopicSelect()
                )
            )
        ]
    }

    struct TopicSelect: ContextualTemplate {

        struct Context {
            let topicResponse: Topic.Response
            let selectedId: Subtopic.ID?

            var subtopicSelect: [SubtopicSelect.Context] {
                return topicResponse.subtopics.map {
                    SubtopicSelect.Context.init(topic: topicResponse.topic, subtopic: $0, isSelected: $0.id == selectedId)
                }
            }

            var isSelected: Bool {
                return topicResponse.subtopics.contains(where: { $0.id == selectedId })
            }
        }

        func build() -> CompiledTemplate {
            optgroup.label(variable(\.topicResponse.topic.name)).child(
                forEach(
                    in: \.subtopicSelect,
                    render: SubtopicSelect()
                )
            )
        }
    }

    struct SubtopicSelect: ContextualTemplate {

        struct Context {
            let topic: Topic
            let subtopic: Subtopic
            let isSelected: Bool
        }

        func build() -> CompiledTemplate {
            return option.if(\.isSelected, add: .selected).value(variable(\.subtopic.id)).child(
                variable(\.subtopic.name) + " - " + variable(\.topic.name)
            )
        }
    }
}

struct TopicPicker : ContextualTemplate {

    struct Context {
        let topics: [TopicSelect.Context]

        init(topics: [Topic], selectedSubtopicId: Topic.ID?) {
            self.topics = ([Topic.unselected] + topics)
                .map { .init(topic: $0, isSelected: $0.id == selectedSubtopicId) }
                .sorted(by: { (first, _) in first.isSelected })
        }
    }

    var idPrefix: String? = nil

    func build() -> CompiledTemplate {
        return [
            label.for(idPrefix + "topic-id").class("col-form-label").child(
                "Tema"
            ),
            select.id(idPrefix + "topic-id").class("select2 form-control select2").dataToggle("select2").dataPlaceholder("Velg ...").required.child(

                forEach(
                    in:     \.topics,
                    render: TopicSelect()
                )
            )
        ]
    }

    struct TopicSelect: ContextualTemplate {

        struct Context {
            let topic: Topic
            let isSelected: Bool
        }

        func build() -> CompiledTemplate {
            return option.if(\.isSelected, add: .selected).value(variable(\.topic.id)).child(
                variable(\.topic.name)
            )
        }
    }
}

