import Foundation
import KognitaCore
import BootstrapKit

extension Task: MultipleSelectItemRepresentable {
    var itemName: String { question }
    var idRepresentable: String { String(id ?? 0) }
}

extension SubjectTest.ModifyResponse {
    var durationInMinutes: Int {
        Int(duration / 60)
    }
}

extension SubjectTest.Templates {

    public struct Modify: HTMLTemplate {

        public struct Context {

            var editCall: String { "editTest(\(test?.id ?? 0))" }
            var deleteCall: String { "deleteTest(\(test?.id ?? 0))" }
            var createTaskUri: String { "/creator/subjects/\(subjectID)/task/multiple/create?isTestable=true" }

            let subjectID: Subject.ID
            let user: User
            let tasks: [Task]
            let test: SubjectTest.ModifyResponse?

            var selectedTaskIDs: [String] {
                test?.taskIDs.map { String($0) } ?? []
            }

            public init(subjectID: Subject.ID, user: User, tasks: [Task], test: SubjectTest.ModifyResponse? = nil) {
                self.subjectID = subjectID
                self.user = user
                self.tasks = tasks
                self.test = test
            }
        }

        var breadcrumbs: [BreadcrumbItem] {
            [
                BreadcrumbItem(link: "/subjects", title: "Fag oversikt")
            ]
        }

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Lag prøve", description: "Lag prøve"))
            ) {
                PageTitle(
                    title: "Lag en prøve",
                    breadcrumbs: breadcrumbs
                )
                Div {
                    DismissableError()
                    Div {
                        Div {
                            Form {

                                Unwrap(context.test) { test in
                                    Input()
                                        .type(.hidden)
                                        .value(test.subjectID)
                                        .id("subject-id")
                                }

                                FormGroup(label: "Overskrift") {
                                    Input()
                                        .id("create-test-title")
                                        .type(.text)
                                        .placeholder("TBL 1")
                                        .value(Unwrap(context.test) { $0.title })
                                }

                                Unwrap(context.test) { test in
                                    FormGroup(label: "Er Team Based Learning") {
                                        Input()
                                            .type(.checkbox)
                                            .id("create-is-tbl")
                                            .isChecked(test.isTeamBasedLearning)
                                    }
                                    .description {
                                        "Ved å velge team based learning, så kan studentene ikke se detaliert resultat rett etter prøven men bare det totale resultatet"
                                    }

                                    FormGroup(label: "Planlagt dato") {
                                        DatePicker()
                                            .id("create-test-scheduled-at")
                                            .selected(date: test.scheduledAt)
                                    }
                                }
                                .else {
                                    FormGroup(label: "Er Team Based Learning") {
                                        Input()
                                            .type(.checkbox)
                                            .id("create-is-tbl")
                                    }
                                    .description {
                                        "Ved å velge team based learning, så kan studentene ikke se detaliert resultat rett etter prøven men bare det totale resultatet"
                                    }

                                    FormGroup(label: "Planlagt dato") {
                                        DatePicker()
                                            .id("create-test-scheduled-at")
                                    }
                                }

                                FormGroup(label: "Varighet (minutter)") {
                                    Input()
                                        .id("create-test-duration")
                                        .type(.number)
                                        .placeholder("10")
                                        .value(Unwrap(context.test) { $0.durationInMinutes })
                                }

                                FormGroup(label: "Oppgaver") {
                                    MultipleSelect(
                                        items: context.tasks,
                                        id: "create-test-tasks"
                                    )
                                    .isSelected { item in
                                        InCollectionCondition(
                                            value: item.idRepresentable,
                                            array: self.context.selectedTaskIDs
                                        )
                                    }
                                }
                                .description {
                                    "Her vil bare oppgaver som er markert med 'ikke for øving' bli vist. Du kan lage en oppgave "
                                }

                                Anchor {
                                    "Lag oppgave"
                                }
                                .href(context.createTaskUri)
                                .button(style: .primary)
                                .float(.bottom)
                                .margin(.zero, for: .top)
                                .margin(.three, for: .bottom)

                                FormGroup(label: "Passord") {
                                    Input()
                                        .type(.text)
                                        .id("create-test-password")
                                        .placeholder("EksempelPassord")
                                        .value(Unwrap(context.test) { $0.password })
                                }

                                IF(context.test.isDefined) {
                                    Button {
                                        "Lagre Test"
                                    }
                                    .on(click: context.editCall)
                                    .type(.button)
                                    .button(style: .primary)

                                    Button {
                                        "Delete Test"
                                    }
                                    .on(click: context.deleteCall)
                                    .type(.button)
                                    .button(style: .danger)
                                    .margin(.one, for: .left)
                                }
                                .else {
                                    Button {
                                        "Lagre Test"
                                    }
                                    .on(click: "createTest()")
                                    .type(.button)
                                    .button(style: .primary)
                                }
                            }
                        }.class("p-2")
                    }.class("modal-body")
                }.class("card")
            }
            .scripts {
                Script().source("/assets/js/subject-test/json-data.js").type("text/javascript")
                Script().source("/assets/js/dismissable-error.js").type("text/javascript")

                IF(context.test.isDefined) {
                    Script().source("/assets/js/subject-test/edit.js").type("text/javascript")
                    Script().source("/assets/js/subject-test/delete.js").type("text/javascript")
                }
                .else {
                    Script().source("/assets/js/subject-test/create.js").type("text/javascript")
                }
            }
        }
    }
}
