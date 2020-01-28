//
//  CreateMultipleChoiseTaskPage.swift
//  App
//
//  Created by Mats Mollestad on 27/02/2019.
//

import BootstrapKit
import KognitaCore

extension MultipleChoiseTask.Templates.Create.Context {
    var modalTitle: String { subject.name + " | Lag flervalgs oppgave"}
    var subjectUri: String { "/subjects/\(subject.id ?? 0)" }
    var subjectContentOverviewUri: String { "/creator/subjects/\(subject.id ?? 0)/overview" }

    var isTestable: Bool {
        guard let task = taskInfo else {
            return false
        }
        return task.isTestable
    }
}

extension MultipleChoiseTask.Templates {
    public struct Create: TemplateView {

        public struct Context {
            let user: User
            let subject: Subject
            let topics: [Topic.Response]

            // Used to edit a task
            let taskInfo: Task?
            let multipleTaskInfo: MultipleChoiseTask.Data?

            public init(user: User, subject: Subject, topics: [Topic.Response], taskInfo: Task? = nil, multipleTaskInfo: MultipleChoiseTask.Data? = nil, selectedTopicId: Int? = nil) {
                self.user = user
                self.subject = subject
                self.topics = topics
//                let sortSelectedTopicId = selectedTopicId ?? taskInfo?.subtopicId
//                self.topics = .init(topics: topics, selectedSubtopicId: sortSelectedTopicId)
                self.taskInfo = taskInfo
                self.multipleTaskInfo = multipleTaskInfo
            }
        }

        var breadcrumbs: [BreadcrumbItem] {
            [
                BreadcrumbItem(link: "/subjects", title: "Fag oversikt"),
                BreadcrumbItem(link: ViewWrapper(view: context.subjectUri), title: ViewWrapper(view: context.subject.name)),
                BreadcrumbItem(link: ViewWrapper(view: context.subjectContentOverviewUri), title: "Innholds oversikt")
            ]
        }

        public var body: HTML {

            return ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Lag oppgave", description: "Lag oppgave"))
            ) {

                PageTitle(title: "Lag flervalgs oppgave", breadcrumbs: breadcrumbs)
                FormCard(title: context.modalTitle) {

                    Text {
                        "Velg tema"
                    }
                    .style(.heading3)
                    .text(color: .dark)

                    Unwrap(context.taskInfo) { task in
                        SubtopicPicker(
                            label: "Undertema",
                            idPrefix: "create-multiple-",
                            topics: context.topics
                        )
                        .selected(id: task.subtopicID)
                    }
                    .else {
                        SubtopicPicker(
                            label: "Undertema",
                            idPrefix: "create-multiple-",
                            topics: context.topics
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
                                ""
//                                                IF(context.value(at: \.taskInfo?.examPaperSemester).isDefined) {
//                                                    Option {
//                                                        context.value(at: \.taskInfo?.examPaperSemester?.rawValue)
//                                                    }
//                                                    .value(context.value(at: \.taskInfo?.examPaperSemester?.rawValue))
//                                                    .isSelected(true)
//                                                }
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
                                .value(Unwrap(context.taskInfo) { $0.examPaperYear })
                                .required()
                        }
                        .column(width: .six, for: .medium)
                    }
                    .class("form-row")

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

                    FormGroup {
                        Div {
                            Unwrap(context.taskInfo) {
                                $0.description
                                    .escaping(.unsafeNone)
                            }
                        }
                        .id("create-multiple-description")
                    }
                    .customLabel {
                        Text {
                            "Oppgavetekst"
                        }
                        .style(.heading3)
                        .text(color: .dark)
                    }

                    FormGroup {
                        TextArea {
                            Unwrap(context.taskInfo) {
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
                            .isChecked(context.multipleTaskInfo.isDefined && context.multipleTaskInfo.unsafelyUnwrapped.isMultipleSelect)
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
                            Div().id("create-multiple-choise")
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
                        Unwrap(context.multipleTaskInfo) { (multiple: TemplateValue<MultipleChoiseTask.Data>) in
                            ForEach(in: multiple.choises) { choise in
                                ChoiseRow(
                                    canSelectMultiple: multiple.isMultipleSelect,
                                    choise: choise
                                )
                            }
                        }
                    }
                    .id("create-multiple-choises")

                    FormGroup {
                        Div()
                            .id("create-multiple-solution")
                    }
                    .customLabel {
                        Text {
                            "Løsningsforslag"
                        }
                        .style(.heading3)
                        .text(color: .dark)
                    }

                    DismissableError()

                    Button {
                        MaterialDesignIcon(icon: .save)
                        " Lagre"
                    }
                    .type(.button)
                    .on(click: IF(context.taskInfo.isDefined) { "editMultipleChoise();" }.else { "createMultipleChoise();" })
                    .class("mb-3 mt-3")
                    .button(style: .success)
                }
            }
            .header {
                Link().href("/assets/css/vendor/summernote-bs4.css").relationship(.stylesheet).type("text/css")
                Link().href("https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0/katex.min.css").relationship(.stylesheet)
            }
            .scripts {
                Script(source: "/assets/js/vendor/summernote-bs4.min.js")
                Script(source: "https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0/katex.min.js")
                Script(source: "/assets/js/vendor/summernote-math.js")
                Script(source: "/assets/js/dismissable-error.js")
                Script(source: "/assets/js/multiple-choise/json-data.js")
                Script(source: "/assets/js/multiple-choise/modify-task.js")

                IF(context.taskInfo.isDefined) {
                    Script().source("/assets/js/multiple-choise/edit.js")
                }.else {
                    Script().source("/assets/js/multiple-choise/create.js")
                }
            }
        }

        struct ChoiseRow: HTMLComponent {

            let canSelectMultiple: TemplateValue<Bool>
            let choise: TemplateValue<MultipleChoiseTaskChoise>

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

extension MultipleChoiseTaskChoise {
    var htmlChoiseID: String { "choise--\(id ?? 0)" }
    var deleteCall: String { "deleteChoise(-\(id ?? 0));" }
}

extension Button: FormInput {}
