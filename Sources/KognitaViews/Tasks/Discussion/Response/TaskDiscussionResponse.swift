//
//  TaskDiscussionResponse.swift
//  KognitaViews
//
//  Created by Eskild Brobak on 27/02/2020.
//
import Foundation
import BootstrapKit
import KognitaCore


struct DiscussionResponse: HTMLPage {

    let response: TemplateValue<TaskDiscussion.Pivot.Response.Details>

    public var body: HTML {
        Div {
            MaterialDesignIcon(.accountCircle)
                .float(.left)
                .style(css: "font-size: 40px;")
                .margin(.two, for: .right)

            Div {
                Div {
                    Text {
                        response.username

                        Unwrap(response.createdAt) { (createdAt: TemplateValue<Date>) in
                            Small { createdAt.style(date: .short, time: .short) }
                                .margin(.one, for: .left)
                        }
                    }
                    .style(.heading5)
                    .margin(.zero, for: .top)

                    Text {
                        response.response
                    }
                    .style(.lead)
                    .margin(.one, for: .bottom)
                    .padding(.two, for: .bottom)
                }
            }
            .display(.flex)
            .margin(.two, for: .top)
        }
        .class("border-bottom border-light")
        .enviroment(locale: "nb")
    }
}
