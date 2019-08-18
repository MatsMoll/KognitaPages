//
//  SubjectPracticeModal.swift
//  App
//
//  Created by Mats Mollestad on 27/02/2019.
//
// swiftlint:disable line_length nesting

import HTMLKit
import KognitaCore

extension AttributableNode {

    func dataBtsPrefix(_ value: CompiledTemplate) -> Self {
        return add(.init(attribute: "data-bts-prefix", value: value))
    }
}

public struct SubjectPracticeModal: LocalizedTemplate {

    public init() {}

    public static var localePath: KeyPath<[Topic], String>?

    public enum LocalizationKeys: String {
        case startText = "subject.session.start"
        case workGoal = "subject.session.work.goal"
        case workGoalUnit = "subject.session.work.goal.unit"
        case topicsTitle = "subject.session.topics.title"
        case topicsDescription = "subject.session.topics.description"
        case topicsSelect = "subject.session.topics.select"
    }

    public typealias Context = [Topic]

    public func build() -> CompiledTemplate {
        return
            div.class("modal fade").id("start-practice-session").tabindex("-1").role("dialog").ariaLabelledby("practice-modal-label").ariaHidden("true").child(
                div.class("modal-dialog modal-dialog-centered modal-lg").child(
                    div.class("modal-content").child(
                        div.class("modal-header bg-light").child(
                            h4.class("modal-title").id("practice-modal-label").child(
                                localize(.startText)
                            ),
                            button.type("button").class("close").dataDismiss("modal").ariaHidden("true").child(
                                "×"
                            )
                        ),
                        div.class("modal-body").child(
                            div.class("p-2").child(

                                div.class("form-group mb-3").child(
                                    label.child(
                                        localize(.workGoal)
                                    ),
                                    input.id("task-number-input")
                                        .value("5")
                                        .dataToggle("touchspin")
                                        .type("text")
                                        .dataBtsPrefix(localize(.workGoalUnit))
                                ),

                                div.class("tab-pane show").id("select-topics").child(
                                    p.class("mb-1 mt-3 font-weight-bold text-secondery").child(
                                        localize(.topicsTitle)
                                    ),
                                    p.class("text-muted font-14").child(
                                        localize(.topicsDescription)
                                    ),

                                    // Select
                                    select.id("practice-topic-selector").class("select2 form-control select2-multiple").dataToggle("select2").multiple.dataPlaceholder(localize(.topicsSelect)).child(
                                        optgroup.label("Hele temaer").child(
                                            forEach(render: SubjectMappingTestModal.ModalSelectOption())
                                        )
                                    )
                                ),

                                div.class("mt-4").child(
                                    button.type("button").onclick("startPracticeSession();").class("btn btn-primary btn-rounded mb-3").child(
                                        " " + localize(.startText)
                                    )
                                )
                            )
                        )
                    )
                )
        )
    }
}
