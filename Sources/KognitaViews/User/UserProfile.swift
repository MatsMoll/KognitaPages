//
//  UserProfile.swift
//  KognitaViews
//
//  Created by Eskild Brobak on 11/02/2020.
//

import BootstrapKit

extension User.Templates {
    struct ProfileCard: HTMLComponent {

        let user: TemplateValue<User>

        var body: HTML {
            Card {
                Unwrap(user.pictureUrl) { pictureUrl in
                    Div {
                        Img()
                            .class("rounded")
                            .alt("profile picture")
                            .style(css: "width: 80px; height: 80px;")
                            .source(pictureUrl)
                    }
                    .text(alignment: .center)
                }.else {
                    Text { MaterialDesignIcon(.accountCircle) }
                        .style(.display1)
                        .text(alignment: .center)
                }

                Text { "Brukernavn: " }
                    .margin(.three, for: .top)
                    .margin(.one, for: .bottom)

                Text { user.username }
                    .style(.heading4)

                Text { "Email: " }
                    .margin(.three, for: .top)
                    .margin(.one, for: .bottom)

                Text { user.email }
                    .style(.heading4)
            }
        }
    }
    
    struct CreateUserCard: HTMLComponent {
        
        var body: HTML {
            Card {
                Text { MaterialDesignIcon(.accountCircle) }
                    .style(.display1)
                    .text(alignment: .center)

                Text { Strings.notLoggedIn }
                
                Anchor {
                    MaterialDesignIcon(.login)
                        .margin(.one, for: .right)
                    Strings.loginButton.localized()
                }
                .button(style: .light)
                .href(Paths.login)
                
                FeideLoginButton()
                    .margin(.one, for: .left)
                
                Break()
                
                Anchor {
                    MaterialDesignIcon(.accountPlus)
                        .margin(.one, for: .right)
                    Strings.registerTitle.localized()
                }
                .button(style: .primary)
                .href(Paths.signup)
                .margin(.one, for: .top)
            }
        }
    }
}

extension User.Templates {
    public struct Profile: HTMLTemplate {

        public struct Context {
            let user: User
            let subjects: [Subject.ListOverview]

            public init(user: User, subjects: [Subject.ListOverview]) {
                self.user = user
                self.subjects = subjects
            }
        }

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Brukerprofil", description: "Brukerprofil", showCookieMessage: false))

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

                            Text { "Brukernavn: " }
                                .margin(.three, for: .top)
                                .margin(.one, for: .bottom)

                            Text { context.user.username }
                                .style(.heading4)

                            Text { "Email: " }
                                .margin(.three, for: .top)
                                .margin(.one, for: .bottom)

                            Text { context.user.email }
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
                            "Dine emner"
                        }
                        .style(.heading2)

                        Row {
                            ForEach(in: context.subjects) { subject in
                                Pages.SubjectCard(subject: subject)
                            }
                        }
                    }
                    .column(width: .eight, for: .large)
                    .column(width: .twelve)
                }
            }
            .scripts {
                Script().source("https://cdn.jsdelivr.net/npm/marked/marked.min.js")
                Script().source("/assets/js/markdown-renderer.js")
            }
        }
    }
}
