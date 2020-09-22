//
//  TaskDiscussionResponse.swift
//  KognitaViews
//
//  Created by Eskild Brobak on 27/02/2020.
//
import Foundation
import BootstrapKit

extension TaskDiscussionResponse {
    var fetchAResponseCall: String { "fetchADiscussionResponse(this)" }
}

struct DiscussionResponse: HTMLComponent {

    let response: TemplateValue<TaskDiscussionResponse>

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

                        IF(response.isNew) {
                            Span { "New " }.class("badge badge-primary")
                        }
                    }
                    .style(.heading5)
                    .margin(.zero, for: .top)

                    Text {
                        response.response
                            .escaping(.unsafeNone)
                    }
                    .style(.lead)
                    .class("render-markdown response")

                    Button {
                        "Legg til en kommentar"
                    }
                    .button(style: .muted)
                    .button(size: .extraSmall)
                    .margin(.one, for: .bottom)
                    .padding(.two, for: .bottom)
                    .on(click: response.fetchAResponseCall)
                }
            }
            .display(.flex)
            .margin(.two, for: .top)
        }
        .class("border-bottom border-light")
        .enviroment(locale: "nb_NO")
    }
}
