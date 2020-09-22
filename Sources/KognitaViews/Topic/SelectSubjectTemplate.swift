//
//  SelectSubjectTemplate.swift
//  App
//
//  Created by Mats Mollestad on 20/08/2019.
//
// swiftlint:disable line_length nesting

import Foundation
import BootstrapKit

extension Subject.Templates {
    public struct SelectRedirect: HTMLTemplate {

        public struct Context {
            let user: User
            let subjects: [Subject]
            let startPath: String
            let endPath: String

            public init(user: User, subjects: [Subject], redirectPathStart: String, redirectPathEnd: String) {
                self.user = user
                self.subjects = subjects
                self.startPath = redirectPathStart
                self.endPath = redirectPathEnd
            }
        }

        public init() {}

        public let context: TemplateValue<Context> = .root()

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Velg fag", description: "Velg fag"))
            ) {
                Row {
                    Div {
                        Div {
                            Div {
                                OrderedList {
                                    ListItem {
                                        "localize(.title)"
                                    }
                                    .class("breadcrumb-item active")
                                }
                                .class("breadcrumb m-0")
                            }
                            .class("page-title-right")
                        }
                        .class("page-title-box")
                    }
                    .class("col-12")
                }
                H3 {
                    "Velg tema"
                }
                Row {
                    ForEach(in: context.subjects) { subject in
                        SelectCard(
                            subject: subject,
                            startPath: context.startPath,
                            endPath: context.endPath
                        )
                    }
                }
            }
        }

        struct SelectCard: HTMLComponent {

            let subject: TemplateValue<Subject>
            let startPath: TemplateValue<String>
            let endPath: TemplateValue<String>

            var body: HTML {
                Div {
                    Anchor {
                        Div {
                            Div {
                                H3 { subject.name }
                                Small { subject.category }
                                    .class("badge badge-light")
                            }
                            .class("card-header text-white")

                            Div {
                                P {
                                    subject.description
                                        .escaping(.unsafeNone)
                                }
                                Button { "Lag tema" }
                                    .button(style: .primary)
                                    .isRounded()
                            }
                            .class("card-body position-relative")
                        }
                        .class("card d-block")
                    }
                    .href(startPath + subject.id + endPath).class("text-dark")
                }
                .class("col-md-6 col-xl-6")
            }
        }
    }
}
