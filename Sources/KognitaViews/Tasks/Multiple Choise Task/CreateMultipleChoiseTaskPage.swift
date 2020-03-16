//
//  CreateMultipleChoiseTaskPage.swift
//  App
//
//  Created by Mats Mollestad on 27/02/2019.
//

import BootstrapKit
import KognitaCore

extension MultipleChoiseTask.Templates.Create.Context {
    var modalTitle: String { content.subject.name + " | Lag flervalgs oppgave"}
    var subjectUri: String { "/subjects/\(content.subject.id)" }
    var subjectContentOverviewUri: String { "/creator/subjects/\(content.subject.id)/overview" }

    var subjectName: String {
        content.subject.name
    }

    var isEditingTask: Bool { content.task != nil }
}

extension MultipleChoiseTask.Templates {
    public struct Create: TemplateView {

        public struct Context {
            let user: User
            let content: MultipleChoiseTask.ModifyContent
            let wasUpdated: Bool
            let isTestable: Bool
            let isModerator: Bool

            public init(user: User, content: MultipleChoiseTask.ModifyContent, isModerator: Bool, wasUpdated: Bool = false, isTestable: Bool = false) {
                self.user = user
                self.content = content
                self.wasUpdated = wasUpdated
                self.isModerator = isModerator
                if let task = content.task {
                    self.isTestable = task.isTestable
                } else {
                    self.isTestable = isTestable
                }
            }
        }

        var breadcrumbs: [BreadcrumbItem] {
            [
                BreadcrumbItem(link: "/subjects", title: "Fag oversikt"),
                BreadcrumbItem(link: ViewWrapper(view: context.subjectUri), title: ViewWrapper(view: context.subjectName)),
                BreadcrumbItem(link: ViewWrapper(view: context.subjectContentOverviewUri), title: "Innholds oversikt")
            ]
        }

        public var body: HTML {

            return ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Lag oppgave", description: "Lag oppgave"))
            ) {

                PageTitle(title: "Lag flervalgs oppgave", breadcrumbs: breadcrumbs)
                IF(context.wasUpdated) {
                    Alert {
                        "Endringene ble lagret"
                    }
                    .background(color: .success)
                    .text(color: .white)
                    .isDismissable(true)
                }
                FormCard(title: context.modalTitle) {

                    Text {
                        "Velg tema"
                    }
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

                    Text {
                        "Eksamens oppgave?"
                    }
                    .style(.heading3)
                    .text(color: .dark)

                    Div {
                        FormGroup(label: "Eksamensett semester") {
                            Select {
                                Option {
                                    "Ikke eksamensoppgave"
                                }
                                .value("")

                                Option {
                                    "Høst"
                                }
                                .value("fall")

                                Option {
                                    "Vår"
                                }
                                .value("spring")
                            }
                            .id("create-multiple-exam-semester")
                            .class("select2 form-control select2")
                            .data(for: "toggle", value: "select2")
                            .data(for: "placeholder", value: "Velg ...")
                        }
                        .column(width: .six, for: .medium)

                        FormGroup(label: "År") {
                            Input()
                                .type(.number)
                                .class("form-control")
                                .id("create-multiple-exam-year")
                                .placeholder("2019")
                                .value(Unwrap(context.content.task) { $0.examPaperYear })
                                .required()
                        }
                        .column(width: .six, for: .medium)
                    }
                    .class("form-row")

                    IF(context.isModerator) {
                        Text {
                            "Bruk på prøver"
                        }
                        .style(.heading3)
                        .text(color: .dark)

                        CustomControlInput(
                            label: "Ved å velge denne kan man bruke oppgaven på prøver, men ikke til å øve",
                            type: .checkbox,
                            id: "create-multiple-testable"
                        )
                            .margin(.three, for: .bottom)
                            .isChecked(context.isTestable)
                    }

                    FormGroup {
                        TextArea {
                            Unwrap(context.content.task) {
                                $0.description
                                    .escaping(.unsafeNone)
                            }
                        }
                        .id("create-multiple-description")
                        .placeholder("Du har gitt en funksjon ...")
                    }
                    .customLabel {
                        Text {
                            "Innledelse"
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
                    .description {
                        Div {
                            "Kun tillatt med bokstaver, tall, mellomrom og enkelte tegn (. , : ; ! ?)"
                        }
                        .class("invalid-feedback")
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
                            "Ved å ha på dette kan man velge flere riktige svar"
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
                            TextArea().id("create-multiple-choise")
                        }
                        .column(width: .eleven)

                        FormGroup(label: "Legg til") {
                            Button {
                                "+"
                            }
                            .type(.button)
                            .background(color: .success)
                            .isRounded()
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

                    FormGroup {
                        MarkdownEditor(id: "solution") {
                            Unwrap(context.content.task) { task in
                                task.solution
                                    .escaping(.unsafeNone)
                            }
                        }
                        .placeholder("Gitt at funksjonen er konveks, så fører det til at ...")
                        .onChange { editor in
                            Script.solutionScore(editorName: editor)
                        }
                    }
                    .customLabel {
                        Text {
                            "Løsningsforslag"
                        }
                        .style(.heading3)
                        .text(color: .dark)
                    }
                    .description {
                        TaskSolution.Templates.Requmendations()
                    }

                    DismissableError()

                    Button {
                        MaterialDesignIcon(icon: .save)
                        " Lagre"
                    }
                    .type(.button)
                    .on(click: IF(context.isEditingTask) { "editMultipleChoise();" }.else { "createMultipleChoise();" })
                    .class("mb-3 mt-3")
                    .button(style: .success)
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
                Script(source: "/assets/js/multiple-choise/json-data.js")
                Script(source: "/assets/js/multiple-choise/modify-task.js")

                IF(context.isEditingTask) {
                    Script().source("/assets/js/multiple-choise/edit.js")
                }.else {
                    Script().source("/assets/js/multiple-choise/create.js")
                }
            }
        }

        struct ChoiseRow: HTMLComponent {

            let canSelectMultiple: TemplateValue<Bool>
            let choise: TemplateValue<MultipleChoiseTaskChoise.Data>

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
                                choise.choise
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

extension MultipleChoiseTaskChoise.Data {
    var htmlChoiseID: String { "choise--\(id)" }
    var deleteCall: String { "deleteChoise(-\(id));" }
}

extension Button: FormInput {}
