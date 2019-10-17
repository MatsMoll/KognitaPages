//
//  SelectSubjectTemplate.swift
//  App
//
//  Created by Mats Mollestad on 20/08/2019.
//
// swiftlint:disable line_length nesting

import Foundation
import BootstrapKit
import KognitaCore

extension Subject.Templates {
    public struct SelectRedirect: TemplateView {

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

        public let context: RootValue<Context> = .root()

        public var body: View {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Velg Fag", description: "Velg Fag")),
                content:
                Row {
                    Div {
                        Div {
                            Div {
                                OrderdList {
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
                } +
                H3 {
                    "Velg tema"
                } +
                Row {
                    ForEach(in: context.subjects) { subject in
                        SelectCard(
                            subject: subject,
                            startPath: context.startPath,
                            endPath: context.endPath
                        )
                    }
                }
            )
        }

        struct SelectCard<A, B>: StaticView {

            let subject: TemplateValue<A, Subject>
            let startPath: TemplateValue<B, String>
            let endPath: TemplateValue<B, String>

            var body: View {
                Div {
                    Anchor {
                        Div {
                            Div {
                                H3 {
                                    subject.name
                                }
                                Small {
                                    subject.category
                                }
                                .class("badge badge-light")
                            }
                            .class("card-header text-white bg-" + subject.colorClass.rawValue)

                            Div {
                                P {
                                    subject.description
                                        .escaping(.unsafeNone)
                                }
                                Button {
                                    "Lag tema"
                                }
                                .class("btn btn-" + subject.colorClass.rawValue + " btn-rounded")
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

