//
//  SubjectDetailExamCard.swift
//  KognitaViews
//
//  Created by Mats Mollestad on 06/11/2020.
//

import Foundation
import KognitaModels

extension Exam.WithCompletion {
    var startExamCall: String {
        "startExam(\(id))"
    }
}

extension Subject.Templates {
    struct ExamCard: HTMLComponent {

        let exam: TemplateValue<Exam.WithCompletion>

        var body: HTML {
            Card {
                Text { exam.description }
                    .style(.heading3)

                Small {
                    "Antall oppgaver: "
                    exam.numberOfTasks
                }

                Break()

                Button {
                    MaterialDesignIcon(.trophy)
                        .margin(.one, for: .right)
                    "Gjennomfør eksamen"
                }
                .button(style: .light)
                .on(click: exam.startExamCall)
                .isRounded()
                .margin(.two, for: .top)
            }
            .footer {
                Div {
                    Text {
                        exam.score.timesHundred.twoDecimals
                        "%"
                    }
                    .style(.paragraph)
                    .font(style: .bold)
                    .margin(.two, for: .bottom)

                    KognitaProgressBar(value: exam.score.timesHundred)
                }
                .margin(.two, for: .vertical)
            }
        }
    }
}
