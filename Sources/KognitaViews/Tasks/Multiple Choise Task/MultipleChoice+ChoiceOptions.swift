//
//  MultipleChoice+ChoiceOptions.swift
//  KognitaCore
//
//  Created by Mats Mollestad on 07/11/2020.
//

import Foundation

extension MultipleChoiceTask.Templates {

    struct ChoiceContext {
        let isSelected: Bool
        var isCorrect: Bool { choice.isCorrect }
        let choice: MultipleChoiceTaskChoice

        init(choice: MultipleChoiceTaskChoice, selectedChoises: [MultipleChoiceTaskChoice.ID] = []) {
            self.isSelected = selectedChoises.contains(choice.id)
            self.choice = choice
        }
    }

    struct ChoiceOption: HTMLComponent {

        let hasBeenAnswered: Conditionable
        let canSelectMultiple: Conditionable
        let choice: TemplateValue<ChoiceContext>

        var body: HTML {
            Div {
                Div {
                    Div {
                        Input()
                            .name("choiseInput")
                            .class("custom-control-input")
                            .id(choice.choice.id)
                            .isChecked(choice.isSelected)
                            .modify(if: hasBeenAnswered) {
                                $0.add(HTMLAttribute(attribute: "disabled", value: "disabled"))
                            }
                            .modify(if: canSelectMultiple) {
                                $0.type(.checkbox)
                            }
                            .modify(if: !canSelectMultiple) {
                                $0.type(.radio)
                            }
                        Label {
                            choice.choice.choice
                                .escaping(.unsafeNone)
                        }
                        .class("custom-control-label")
                        .for(choice.choice.id)
                        .modify(if: hasBeenAnswered && (choice.isSelected || choice.isCorrect)) {
                            $0.text(color: .white)
                        }
                    }
                    .class("custom-control")
                    .modify(if: canSelectMultiple) {
                        $0.class("custom-checkbox")
                    }
                    .modify(if: !canSelectMultiple) {
                        $0.class("custom-radio")
                    }
                }
                .class("p-2 text-secondary")
                .id(choice.choice.id + "-div")
                .modify(if: hasBeenAnswered && choice.isCorrect) {
                    $0.background(color: .success)
                }
                .modify(if: choice.isSelected && !choice.isCorrect) {
                    $0.background(color: .danger)
                }
            }
            .class("card mb-1 shadow-none border")
        }
    }
}
