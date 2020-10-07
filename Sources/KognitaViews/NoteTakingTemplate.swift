//
//  NoteTakingTemplate.swift
//  KognitaViews
//
//  Created by Mats Mollestad on 17/09/2020.
//

import Foundation

struct NoteTakingTemplate: HTMLTemplate {

    struct Context {
        let user: User
    }

    var body: HTML {

        ContentBaseTemplate(
            userContext: context.user,
            baseContext: .constant(.init(title: "Notater", description: "Ta notater", showCookieMessage: false))
        ) {
            PageTitle(title: "Ta notater")

            ContentStructure {
                Div().id("notes")
            }
            .secondary {
                Card {
                    Text { "Handlinger" }.style(.heading3)
                }
            }
        }
    }

    struct Note: HTMLTemplate {

        typealias Context = KognitaModels.LectureNote

        var body: HTML {
            Card {
                Text { context.question }.style(.lead)
                Text { context.solution }
            }
        }
    }
}
