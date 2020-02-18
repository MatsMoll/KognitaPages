//
//  UserProfile.swift
//  KognitaViews
//
//  Created by Eskild Brobak on 11/02/2020.
//

import BootstrapKit
import KognitaCore

extension User.Templates {
    public struct Profile: HTMLTemplate {

        public struct Context {
            let user: User
            let subjects: [Subject]

            public init(user: User, subjects: [Subject]) {
                self.user = user
                self.subjects = subjects
            }
        }

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Brukerprofil", description: "Brukerprofil"))

            ) {
                PageTitle(title: "Brukerprofil")
                Row {
                    Div {
                        Card {
                            Text {
                                MaterialDesignIcon(.accountCircle)
                            }
                            .style(.display1)
                            .text(alignment: .center)

                            Text {
                                "Brukernavn: "
                            }
                            .margin(.three, for: .top)
                            .margin(.one, for: .bottom)

                            Text {
                                context.user.username
                            }
                            .style(.heading4)

                            Text {
                                "Email: "
                            }
                            .margin(.three, for: .top)
                            .margin(.one, for: .bottom)

                            Text {
                                context.user.email
                            }
                            .style(.heading4)

                        }
                    }
                    .column(width: .four, for: .large)
                    .column(width: .twelve)

                    Div {
                        IF(context.user.isEmailVerified == false) {
                            Subject.Templates.VerifyEmailSignifier()
                        }

                        Text {
                            "Dine emner!"
                        }
                        .style(.heading2)

                        Row {
                            ForEach(in: context.subjects) { subject in
                                Subject.Templates.SubjectCard(subject: subject)
                            }
                        }
                    }
                    .column(width: .eight, for: .large)
                    .column(width: .twelve)
                }
            }
            .scripts{
                Script().source("https://cdn.jsdelivr.net/npm/marked/marked.min.js")
                Script().source("/assets/js/markdown-renderer.js")
            }
        }
    }
}
