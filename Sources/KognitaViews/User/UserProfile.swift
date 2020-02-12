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
                            .display(.inline)
                            
                            Text {
                                context.user.username
                            }
                            .display(.inline)
                            .font(style: .bold)

                            Text {
                                "Email: " + context.user.email
                            }

                            Anchor {
                                " "
                                "Endre passord"
                            }
                            .button(style: .primary)
                            .text(color: .white)
                            .href("/reset-password")
                        }
                    }
                    .column(width: .four)

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
                    .column(width: .eight)
                }
            }
        }

    }
}
