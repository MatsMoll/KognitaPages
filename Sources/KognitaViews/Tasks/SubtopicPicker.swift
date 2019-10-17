//
//  SubtopicPicker.swift
//  KognitaViews
//
//  Created by Mats Mollestad on 26/08/2019.
//

import BootstrapKit
import KognitaCore

struct SubtopicPicker<T>: StaticView {

    let idPrefix: View
    let topics: TemplateValue<T, [Topic.Response]>

    var body: View {
        FormGroup(label: idPrefix + "topic-id") {
            Select(topics) { topic in
                OptionGroup {
                    ForEach(in: topic.subtopics) { subtopic in
                        Option {
                            subtopic.name + " - " + topic.topic.name
                        }
                        .value(subtopic.id)
                    }
                }
                .label(topic.topic.name)
            }
            .id(idPrefix + "topic-id")
            .class("select2")
            .data(for: "toggle", value: "select2")
            .data(for: "placeholder", value: "Velg ...")
        }
    }
}

struct TopicPicker<T>: StaticView {

    let topics: TemplateValue<T, [Topic]>
    let selectedTopicId: TemplateValue<T, Topic.ID?>
    var idPrefix: String? = nil

    var body: View {
        Label { "Tema" }
            .for(idPrefix + "topic-id")
            .class("col-form-label") +
        Select {
            ForEach(in: topics) { topic in
                Option {
                    topic.name
                }
                .value(topic.id)
                .isSelected(topic.id == selectedTopicId)
            }
            "TopicSelect"
        }
        .id(idPrefix + "topic-id")
        .class("select2 form-control select2")
        .data(for: "toggle", value: "select2")
        .data(for: "placeholder", value: "Velg ...")
//        .required()

    }
}
