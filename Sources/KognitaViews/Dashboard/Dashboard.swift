//
//  File.swift
//  
//
//  Created by Mats Mollestad on 16/12/2020.
//

import Foundation
import BootstrapKit
import KognitaModels

extension Pages {
    public struct AuthenticatedDashboard: HTMLTemplate {

        /// The context needed to render the template
        public struct Context {
            let user: User
            let list: KognitaModels.Dashboard
            let wasIncorrectPassword: Bool
            let recentlyActiveDiscussions: Bool

            var listComponentContext: DashboardSubjectList.Context { .init(activeSubjects: list.activeSubjects, inactiveSubjects: list.inactiveSubjects) }

            public init(user: User, list: Dashboard, wasIncorrectPassword: Bool, recentlyActiveDiscussions: Bool) {
                self.user = user
                self.list = list
                self.wasIncorrectPassword = wasIncorrectPassword
                self.recentlyActiveDiscussions = recentlyActiveDiscussions
            }
        }

        public init() {}

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Temaliste", description: "Temaliste", showCookieMessage: false))
            ) {

                PageTitle(title: Strings.subjectsTitle.localized())

                Row {
                    Div {
                        SubjectTestList(test: context.list.openedTest)
                        
                        IF(context.user.isEmailVerified == false) {
                            VerifyEmailSignifier()
                        }
                        
                        Unwrap(context.list.recommendedRecap) { recap in
                            RecommendedRecapCard(recap: recap)
                            PracticeSession.Templates.CreateModal()
                        }

                        Text { "Emner" }.style(.heading4)
                        SearchCard()
                        DashboardSubjectList(context: context.listComponentContext)
                    }
                    .column(width: .eight, for: .large)
                    Div {
                        StatisticsCard()
                        User.Templates.ProfileCard(user: context.user)
//                        UserDiscussionCard(recentlyActiveDiscussions: context.recentlyActiveDiscussions)
                        IF(context.user.isAdmin) {
                            CreateSubjectCard()
                        }
                    }
                    .column(width: .four, for: .large)
                }
            }
            .scripts {
                Script().source("/assets/js/vendor/Chart.bundle.min.js")
                Script().source("/assets/js/practice-session-histogram.js")
                Script().source("https://cdn.jsdelivr.net/npm/marked/marked.min.js")
                Script().source("/assets/js/markdown-renderer.js")
                IF(context.wasIncorrectPassword) {
                    Script {
                        """
$("#start-subject-test-modal").modal('show');
"""
                    }
                }
                IF(context.list.potensialSubjects.isEmpty == false) {
                    Script {
                        ##"$("#\##(PotensialRelevantSubjectModal.modalID)").modal('show');"##
                    }
                }

            }
            .active(path: "/subjects")
            .modals {
                Unwrap(context.list.openedTest) { test in
                    SubjectTest.Templates.StartModal(
                        test: test,
                        wasIncorrectPassword: context.wasIncorrectPassword
                    )
                }
                
                IF(context.list.potensialSubjects.isEmpty == false) {
                    PotensialRelevantSubjectModal(
                        activeSubjects: context.list.potensialActiveSubjects,
                        inactiveSubjects: context.list.potensialInactiveSubjects
                    )
                }
            }
        }
    }
    
    public struct UnauthenticatedDashboard: HTMLTemplate {

        /// The context needed to render the template
        public struct Context {
            let subjects: DashboardSubjectList.Context
            let baseContext: BaseTemplateContent
            
            public init(subjects: [Subject.ListOverview], showCoockieMessage: Bool) {
                self.subjects = .init(subjects: subjects)
                self.baseContext = .init(title: "Temaliste", description: "Temaliste", showCookieMessage: showCoockieMessage)
            }
        }

        public init() {}

        public var body: HTML {
            ContentBaseTemplate(baseContext: context.baseContext) {

                PageTitle(title: Strings.subjectsTitle.localized())

                Row {
                    Div {
                        Text { "Emner" }.style(.heading4)
                        SearchCard()
                        DashboardSubjectList(context: context.subjects)
                    }
                    .column(width: .eight, for: .large)
                    Div {
                        User.Templates.CreateUserCard()
                    }
                    .column(width: .four, for: .large)
                }
            }
            .scripts {
                Script().source("https://cdn.jsdelivr.net/npm/marked/marked.min.js")
                Script().source("/assets/js/markdown-renderer.js")
            }
            .active(path: "/subjects")
        }
    }
}
