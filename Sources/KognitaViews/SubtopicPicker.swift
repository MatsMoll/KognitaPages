//
//  SubtopicPicker.swift
//  KognitaViews
//
//  Created by Mats Mollestad on 26/08/2019.
//

import BootstrapKit
import KognitaCore

struct SubtopicPicker: HTMLComponent, AttributeNode {

    var attributes: [HTMLAttribute]
    let label: String
    let idPrefix: HTML
    let topics: TemplateValue<[Topic.Response]>
    private let selectedID: TemplateValue<Subtopic.ID>

    init(label: String, idPrefix: HTML, topics: TemplateValue<[Topic.Response]>) {
        self.label = label
        self.idPrefix = idPrefix
        self.attributes = []
        self.topics = topics
        self.selectedID = .constant(-1)
    }

    private init(label: String, idPrefix: HTML, topics: TemplateValue<[Topic.Response]>, selectedID: TemplateValue<Subtopic.ID>, attributes: [HTMLAttribute]) {
        self.label = label
        self.idPrefix = idPrefix
        self.attributes = []
        self.topics = topics
        self.selectedID = selectedID
    }

    var body: HTML {
        FormGroup(label: label) {
            Select {
                OptionGroup {
                    Option {
                        "Velg undertema"
                    }
                }
                .label("Velg undertema")

                ForEach(in: topics) { topic in
                    OptionGroup {
                        ForEach(in: topic.subtopics) { subtopic in
                            Option {
                                subtopic.name + " - " + topic.topic.name
                            }
                            .value(subtopic.id)
                            .isSelected(subtopic.id == selectedID)
                        }
                    }
                    .label(topic.topic.name)
                }
            }
            .id(idPrefix + "topic-id")
            .class("select2")
            .data(for: "toggle", value: "select2")
            .data(for: "placeholder", value: "Velg ...")
        }
        .add(attributes: attributes)
    }

    func copy(with attributes: [HTMLAttribute]) -> SubtopicPicker {
        .init(label: label, idPrefix: idPrefix, topics: topics, selectedID: selectedID, attributes: attributes)
    }

    func selected(id: TemplateValue<Subtopic.ID>) -> SubtopicPicker {
        .init(label: label, idPrefix: idPrefix, topics: topics, selectedID: id, attributes: attributes)
    }
}

struct TopicPicker: HTMLComponent {

    let topics: TemplateValue<[Topic]>
    let selectedTopicId: TemplateValue<Topic.ID?>
    var idPrefix: String?

    var body: HTML {
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
