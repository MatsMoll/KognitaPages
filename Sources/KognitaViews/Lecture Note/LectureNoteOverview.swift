//
//  LectureNoteOverview.swift
//  KognitaViews
//
//  Created by Mats Mollestad on 21/09/2020.
//

import Foundation

extension LectureNote {

    var htmlID: String { "note-\(id)" }

    public enum Templates {}
}

extension LectureNote.Templates {

    public struct Overview: HTMLTemplate {

        public typealias Context = LectureNote

        public init() {}

        public var body: HTML {
            Card {
                Button {
                    "Rediger"
                    MaterialDesignIcon(.note)
                        .margin(.one, for: .left)
                }
                .button(style: .info)
                .float(.right)
                .data("id", value: context.id)
                .data("subtopic-id", value: context.subtopicID)
                .data("question", value: context.question)
                .data("solution", value: context.solution)
                .toggle(modal: .id(TypingTask.Templates.UpdateModel.identifier))

                Text { context.question }
                    .text(color: .dark)
                    .style(.lead)
                Label { "Notat" }
                Text { context.solution }
            }
            .id(context.htmlID)
        }
    }
}
