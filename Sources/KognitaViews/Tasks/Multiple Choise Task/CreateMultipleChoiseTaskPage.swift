//
//  CreateMultipleChoiceTaskPage.swift
//  App
//
//  Created by Mats Mollestad on 27/02/2019.
//

import BootstrapKit

extension MultipleChoiceTask {
    public enum Templates {}
}

extension MultipleChoiceTask.Templates.Create.Context {
    var modalTitle: String { content.subject.name + " | Lag flervalgsoppgave"}
    var subjectUri: String { "/subjects/\(content.subject.id)" }
    var subjectContentOverviewUri: String { "/creator/subjects/\(content.subject.id)/overview" }

    var subjectName: String {
        content.subject.name
    }

    var isEditingTask: Bool { content.task != nil }

    var saveCall: String {
        if isEditingTask {
            return "editMultipleChoise();"
        } else {
            return "createMultipleChoise();"
        }
    }

    var deleteCall: String? {
        guard let taskID = content.task?.id else {
            return nil
        }
        return "deleteTask(\(taskID), \"tasks/multiple-choise\");"
    }

    var forceDeleteCall: String? {
        guard let taskID = content.task?.id else {
            return nil
        }
        return "forceDelete(\(taskID), \"tasks/multiple-choise\");"
    }

    var isDeleted: Bool { content.task?.isDeleted == true }
}

extension MultipleChoiceTask.Templates {
    public struct Create: HTMLTemplate {

        public struct Context {
            let user: User
            let content: MultipleChoiceTask.ModifyContent
            let wasUpdated: Bool
            let isTestable: Bool
            let isModerator: Bool
            let canEdit: Bool

            public init(user: User, content: MultipleChoiceTask.ModifyContent, isModerator: Bool, wasUpdated: Bool = false, isTestable: Bool = false) {
                self.user = user
                self.content = content
                self.wasUpdated = wasUpdated
                self.isModerator = isModerator
                if let task = content.task {
                    self.canEdit = isModerator ? true : user.id == content.task?.id
                    self.isTestable = task.isTestable
                } else {
                    self.canEdit = true
                    self.isTestable = isTestable
                }
            }
        }

        var breadcrumbs: [BreadcrumbItem] {
            [
                BreadcrumbItem(link: "/subjects", title: "Fagoversikt"),
                BreadcrumbItem(link: ViewWrapper(view: context.subjectUri), title: ViewWrapper(view: context.subjectName)),
                BreadcrumbItem(link: ViewWrapper(view: context.subjectContentOverviewUri), title: "Innholdsoversikt")
            ]
        }

        public var body: HTML {

            return ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Lag oppgave", description: "Lag oppgave", showCookieMessage: false))
            ) {

                PageTitle(title: "Lag flervalgsoppgave", breadcrumbs: breadcrumbs)
                IF(context.wasUpdated) {
                    Alert {
                        "Endringene ble lagret"
                    }
                    .background(color: .success)
                    .text(color: .white)
                    .isDismissable(true)
                }

                Unwrap(context.content.task) { task in
                    IF(task.isDeleted) {
                        Alert {
                            Text { "Denne oppgaven brukes ikke i øvingsett. For å bruke den i øvingsett kan man lagre / redigere oppgaven. Skulle man heller slette den permanent, så er det mulig med å trykke på \"Slett permanent\"" }
                            Button {
                                "Slett permanent"
                                MaterialDesignIcon(.delete)
                                    .margin(.one, for: .left)
                            }
                            .button(style: .danger)
                            .on(click: context.forceDeleteCall)
                        }
                        .isDismissable(false)
                        .background(color: .light)
                    }
                }

                FormCard(title: context.modalTitle) {

                    FormGroup {
                        MarkdownEditor(id: "description") {
                            Unwrap(context.content.task) {
                                $0.description
                                    .escaping(.unsafeNone)
                            }
                        }
                        .placeholder("Du har en gitt funksjon ...")

                    }
                    .customLabel {
                        Text {
                            "Innledning"
                        }
                        .style(.heading3)
                        .text(color: .dark)
                    }

                    FormGroup {
                        TextArea {
                            Unwrap(context.content.task) {
                                $0.question
                            }
                        }
                        .class("form-control")
                        .id("create-multiple-question")
                        .placeholder("Noe å svare på her")
                        .required()
                    }
                    .customLabel {
                        Text {
                            "Spørsmål"
                        }
                        .style(.heading3)
                        .text(color: .dark)
                    }

                    Text {
                        "Kan velge flere alternativer"
                    }
                    .style(.heading3)
                    .text(color: .dark)

                    Div {
                        Input()
                            .type(.checkbox)
                            .class("custom-control-input")
                            .id("create-multiple-select")
                            .isChecked(context.content.isMultipleSelect)
                        Label {
                            "Ved å huke av denne kan man velge flere riktige svar"
                        }
                        .class("custom-control-label")
                        .for("create-multiple-select")
                    }
                    .class("custom-control custom-checkbox")
                    .margin(.two, for: .vertical)

                    Text {
                        "Alternativer"
                    }
                    .style(.heading3)
                    .text(color: .dark)

                    FormRow {
                        FormGroup(label: "Legg til et alternativ") {
                            MarkdownEditor(id: "create-multiple-choise")
                        }
                        .column(width: .eleven)

                        FormGroup(label: "Legg til") {
                            Button {
                                "+"
                            }
                            .type(.button)
                            .background(color: .success)
                            .on(click: "addChoise();")
                            .text(alignment: .center)
                            .text(color: .white)
                            .id("add-button")
                        }
                        .column(width: .one, for: .medium)
                    }
                    .margin(.three, for: .bottom)

                    Label {
                        "Mulige alternativer"
                    }

                    Div {
                        ForEach(in: context.content.choises) { choise in
                            ChoiseRow(
                                canSelectMultiple: context.content.isMultipleSelect,
                                choise: choise
                            )
                        }
                    }
                    .id("create-multiple-choises")

                    Unwrap(context.content.task) { task in
                        IF(task.solutions.count > 1) {
                            TaskSolutionCard(fetchUrl: Script.fetchSolutionEditorUrl)
                        }.else {
                            Unwrap(task.solutions.first) { solution in
                                solutionForm(solution)
                            }
                        }
                    }.else {
                        solutionForm()
                    }

                    Text { "Velg tema" }
                        .style(.heading3)
                        .text(color: .dark)

                    Unwrap(context.content.task) { task in
                        SubtopicPicker(
                            label: "Undertema",
                            idPrefix: "create-multiple-",
                            topics: context.content.topics
                        )
                        .selected(id: task.subtopicID)
                    }
                    .else {
                        SubtopicPicker(
                            label: "Undertema",
                            idPrefix: "create-multiple-",
                            topics: context.content.topics
                        )
                    }

                    Text { "Eksamensoppgave?" }
                        .style(.heading3)
                        .text(color: .dark)

                    Div {
                        FormGroup(label: "Eksamensett semester") {
                            Select {
                                Option { "Ikke eksamensoppgave" }

                                ForEach(in: context.content.exams) { exam in
                                    Option { exam.description }
                                        .value(exam.id)
                                }
                            }
                            .id("card-exam-id")
                            .class("select2 form-control select2")
                            .data(for: "toggle", value: "select2")
                            .data(for: "placeholder", value: "Velg ...")
                        }
                        .column(width: .nine, for: .medium)

                        Div {
                            Label { "Finner ikke riktig eksamen?" }
                            Button { "Registrer eksamen" }
                                .toggle(modal: .id(Exam.Templates.CreateNewModal.identifier))
                                .button(style: .info)
                                .type(.button)

                            Exam.Templates.CreateNewModal(
                                selectorID: "card-exam-id",
                                subjectID: context.content.subject.id
                            )
                        }
                        .column(width: .three, for: .medium)
                    }.class("form-row")

//                    Div {
//                        FormGroup(label: "Eksamensett semester") {
//                            Select {
//                                Option {
//                                    "Ikke eksamensoppgave"
//                                }
//                                .value("")
//
//                                Option {
//                                    "Høst"
//                                }
//                                .value("fall")
//
//                                Option {
//                                    "Vår"
//                                }
//                                .value("spring")
//                            }
//                            .id("create-multiple-exam-semester")
//                            .class("select2 form-control select2")
//                            .data(for: "toggle", value: "select2")
//                            .data(for: "placeholder", value: "Velg ...")
//                        }
//                        .column(width: .six, for: .medium)
//
//                        FormGroup(label: "År") {
//                            Input()
//                                .type(.number)
//                                .class("form-control")
//                                .id("create-multiple-exam-year")
//                                .placeholder("2019")
//                                .value(Unwrap(context.content.task) { $0.examYear })
//                                .required()
//                        }
//                        .column(width: .six, for: .medium)
//                    }
//                    .class("form-row")

                    IF(context.isModerator) {
                        Text {
                            "Bruk på prøver"
                        }
                        .style(.heading3)
                        .text(color: .dark)

                        CustomControlInput(
                            label: "Ved å velge denne kan man bruke oppgaven på prøver men ikke til å øve",
                            type: .checkbox,
                            id: "create-multiple-testable"
                        )
                            .margin(.three, for: .bottom)
                            .isChecked(context.isTestable)
                    }

                    DismissableError()

                    IF(context.canEdit) {
                        Button {
                            MaterialDesignIcon(icon: .check)
                            " Lagre"
                        }
                        .type(.button)
                        .on(click: context.saveCall)
                        .class("mb-3 mt-3")
                        .button(style: .success)

                        IF(context.isDeleted == false) {
                            Unwrap(context.deleteCall) { _ in
                                Button {
                                    MaterialDesignIcon(icon: .delete)
                                    " Slett"
                                }
                                .type(.button)
                                .on(click: context.saveCall)
                                .margin(.three, for: .vertical)
                                .margin(.one, for: .left)
                                .button(style: .danger)
                            }
                        }
                    }
                }
            }
            .header {
                Link().href("/assets/css/vendor/simplemde.min.css").relationship(.stylesheet).type("text/css")
                Link().href("/assets/css/vendor/katex.min.css").relationship(.stylesheet)
            }
            .scripts {
                Script(source: "/assets/js/vendor/simplemde.min.js")
                Script(source: "/assets/js/vendor/marked.min.js")
                Script(source: "/assets/js/vendor/katex.min.js")
                Script(source: "/assets/js/markdown-renderer.js")
                Script(source: "/assets/js/markdown-editor.js")
                Script(source: "/assets/js/dismissable-error.js")
                Script(source: "/assets/js/delete-task.js")
                Script(source: "/assets/js/multiple-choise/json-data.js")
                Script(source: "/assets/js/multiple-choise/modify-task.js")

                IF(context.isEditingTask) {
                    Script().source("/assets/js/multiple-choise/edit.js")
                }.else {
                    Script().source("/assets/js/multiple-choise/create.js")
                }
            }
        }

        private func solutionForm(content: HTML = "", id: HTML = "solution") -> HTML {
            FormGroup {
                MarkdownEditor(id: id) { content }
                    .placeholder("Gitt at funksjonen er konveks, fører det til at ...")
                    .onChange { editor in
                        Script.solutionScore(divID: "solution-req", editorName: editor)
                }
            }
            .customLabel {
                Text { "Løsningsforslag" }
                    .style(.heading3)
                    .text(color: .dark)
            }
            .description {
                TaskSolution.Templates.Requmendations().id("solution-req")
            }
        }

        private func solutionForm(_ solution: TemplateValue<TaskSolution>) -> HTML {
            solutionForm(content: solution.solution.escaping(.unsafeNone))
        }

        struct ChoiseRow: HTMLComponent {

            let canSelectMultiple: TemplateValue<Bool>
            let choise: TemplateValue<MultipleChoiceTaskChoice>

            var body: HTML {
                Card {
                    Div {
                        Div {
                            Input()
                                .name("choiseInput")
                                .class("custom-control-input")
                                .id(choise.id)
                                .isChecked(choise.isCorrect)
                                .modify(if: canSelectMultiple) {
                                    $0.type(.checkbox)
                                }
                                .modify(if: !canSelectMultiple) {
                                    $0.type(.radio)
                                }
                            Label {
                                choise.choice
                                    .escaping(.unsafeNone)
                            }
                            .class("custom-control-label")
                            .for(choise.id)

                            Button {
                                MaterialDesignIcon(icon: .delete)
                            }
                            .type(.button)
                            .button(style: .danger)
                            .isRounded()
                            .on(click: choise.deleteCall)
                            .float(.right)
                        }
                        .class("custom-control")
                        .modify(if: canSelectMultiple) {
                            $0.class("custom-checkbox")
                        }
                        .modify(if: !canSelectMultiple) {
                            $0.class("custom-radio")
                        }
                    }
                    .padding(.two)
                    .text(color: .secondary)
                }
                .class("shadow-none border")
                .id(choise.htmlChoiseID)
                .margin(.one, for: .bottom)
            }
        }
    }
}

extension MultipleChoiceTaskChoice {
    var htmlChoiseID: String { "choise--\(id)" }
    var deleteCall: String { "deleteChoise(-\(id));" }
}

extension Button: FormInput {}
