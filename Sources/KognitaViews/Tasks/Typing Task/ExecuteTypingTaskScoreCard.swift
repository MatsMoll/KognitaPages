//
//  ExecuteTypingTaskScoreCard.swift
//  KognitaCore
//
//  Created by Mats Mollestad on 07/11/2020.
//

import Foundation

extension TypingTask.Templates {
    struct ScoreButton: HTMLComponent {

        let score: Int

        var body: HTML {
            Button { score + 1 }
                .on(click: "registerScore(\(score))")
                .id(score)
                .button(style: .light)
        }
    }

    struct ScoreButtons: HTMLComponent {

        let score: TemplateValue<Double?>

        var body: HTML {
            NodeList {
                Div { ScoreButton(score: 0) }
                    .column(width: .two)
                    .offset(width: .one, for: .all)

                Div { ScoreButton(score: 1) }
                    .column(width: .two)

                Div { ScoreButton(score: 2) }
                    .column(width: .two)

                Div { ScoreButton(score: 3) }
                    .column(width: .two)

                Div { ScoreButton(score: 4) }
                    .column(width: .two)
            }
        }
    }

    struct LevelColumn: HTMLComponent {

        let icon: HTML
        let description: HTML
        let textAlignment: Text.Alignment

        var body: HTML {
            Text {
                icon
                Break()
                description
            }
            .column(width: .four)
            .text(alignment: textAlignment)
            .style(.heading5)
        }
    }
}
