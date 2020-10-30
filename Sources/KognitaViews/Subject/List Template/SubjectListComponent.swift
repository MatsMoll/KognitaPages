//
//  SubjectListComponent.swift
//  KognitaViews
//
//  Created by Mats Mollestad on 30/10/2020.
//

import Foundation

extension Subject.Templates {
    public struct ListComponent: HTMLTemplate {

        static let subjectListID = "subject-list"

        public struct Context {
            let activeSubjects: [Subject.ListOverview]
            let inactiveSubjects: [Subject.ListOverview]

            init(activeSubjects: [Subject.ListOverview], inactiveSubjects: [Subject.ListOverview]) {
                self.activeSubjects = activeSubjects
                self.inactiveSubjects = inactiveSubjects
            }

            public init(subjects: [Subject.ListOverview]) {
                self.activeSubjects = subjects.filter { $0.isActive }
                self.inactiveSubjects = subjects.filter { $0.isActive == false }
            }
        }

        @TemplateValue(Context.self)
        public var context

        public init(context: TemplateValue<Context> = .root()) {
            self.context = context
        }

        public var body: HTML {
            Div {
                Subject.Templates.ActiveSubjects(subjects: context.activeSubjects)
                InactiveSubjectsSection(subjects: context.inactiveSubjects)
            }
            .id(ListComponent.subjectListID)
        }

        struct InactiveSubjectsSection: HTMLComponent {

            @TemplateValue([Subject.ListOverview].self)
            var subjects

            var body: HTML {
                NodeList {
                    Text { "Andre emner" }
                        .style(.heading3)
                    IF(subjects.isEmpty) {
                        Text { "Det finnes ingen andre emner" }
                            .style(.heading4)
                    }.else {
                        Row {
                            ForEach(in: subjects) { subject in
                                SubjectCard(subject: subject)
                            }
                        }
                    }
                }
            }
        }
    }
}
