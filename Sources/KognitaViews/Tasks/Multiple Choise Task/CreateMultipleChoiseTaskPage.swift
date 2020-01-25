//
//  CreateMultipleChoiseTaskPage.swift
//  App
//
//  Created by Mats Mollestad on 27/02/2019.
//

import BootstrapKit
import KognitaCore

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

        public init() {}

        public let context: TemplateValue<Context> = .root()

        public var body: HTML {

            return ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Lag oppgave", description: "Lag oppgave"))
            ) {
                FormCard(title: context.subject.name + " | Lag flervalgs oppgave") {

                    SubtopicPicker(
                        label: "Undertema",
                        idPrefix: "create-multiple-",
                        topics: context.topics
                    )

                    Div {
                        Div {
                            Label {
                                "Eksamensett semester"
                            }.for("create-multiple-exam-semester").class("col-form-label")
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
//                                            .required()
                        }.class("form-group col-md-6")

                        FormGroup(label: "År") {
                            Input()
                                .type(.number)
                                .class("form-control")
                                .id("create-multiple-exam-year")
                                .placeholder("2019")
                                .value(Unwrap(context.taskInfo) { $0.examPaperYear })
                                .required()
                        }
                        .column(width: .six)
                    }
                    .class("form-row")

                    CustomControlInput(
                        label: "Bruk på prøver",
                        type: .checkbox,
                        id: "create-multiple-testable"
                    )
                    .margin(.three, for: .bottom)


                    FormGroup(label: "Oppgavetekst") {
                        Div {
                            Unwrap(context.taskInfo) {
                                $0.description
                                    .escaping(.unsafeNone)
                            }
                        }
                        .id("create-multiple-description")
                    }


                    FormGroup(label: "Spørsmål") {
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
                    .description {
                        Div {
                            "Kun tillatt med bokstaver, tall, mellomrom og enkelte tegn (. , : ; ! ?)"
                        }
                        .class("invalid-feedback")
                    }

                    FormGroup(label: "Løsning") {
                        Div()
                            .id("create-multiple-solution")
                    }

                    Div {
                        Input()
                            .type(.checkbox)
                            .class("custom-control-input")
                            .id("create-multiple-select")
                            .isChecked(context.multipleTaskInfo.isDefined && context.multipleTaskInfo.unsafelyUnwrapped.isMultipleSelect)
                        Label {
                            "Kan velge fler enn et svar"
                        }
                        .class("custom-control-label")
                        .for("create-multiple-select")
                    }
                    .class("custom-control custom-checkbox mt-3")

                    FormRow {
                        FormGroup(label: "Legg til et valg") {
                            Div().id("create-multiple-choise")
                        }
                        .column(width: .ten)
                        Div {
                           Button {
                               "+"
                           }
                           .type(.button)
                           .class("btn btn-success btn-rounded")
                           .on(click: "addChoise();")
                       }
                       .class("form-group col-md-2")
                    }

                    Div {
                        Table {
                            TableHead {
                                TableRow {
                                    TableHeader { "Valg" }
                                    TableHeader { "Er riktig" }
                                    TableHeader { "Handlinger" }
                                }
                            }
                            TableBody {
                                Unwrap(context.multipleTaskInfo) { taskInfo in
                                    ForEach(in: taskInfo.choises) { choise in
                                        ChoiseRow(choise: choise)
                                    }
                                }
                            }
                            .id("create-multiple-choises")
                        }
                        .class("col-12")
                    }
                    .class("form-group")

                    DismissableError()

                    Button {
                        Italic().class("mdi mdi-save")
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
            }.scripts {
                Script().source("/assets/js/vendor/summernote-bs4.min.js")
                Script().source("https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0/katex.min.js")
                Script().source("/assets/js/vendor/summernote-math.js")
                Script().source("/assets/js/dismissable-error.js")
                Script().source("/assets/js/multiple-choise/json-data.js")

                IF(context.taskInfo.isDefined) {
                    Script().source("/assets/js/multiple-choise/edit.js")
                }.else {
                    Script().source("/assets/js/multiple-choise/create.js")
                }
            }
        }

        struct ChoiseRow: StaticView {

            let choise: TemplateValue<MultipleChoiseTaskChoise>
            var switchId: HTML { "switch-" + choise.id }

            var body: HTML {
                TableRow {
                    TableCell {
                        choise.choise.escaping(.unsafeNone)
                    }
                    TableCell {
                        Input()
                            .type(.checkbox)
                            .id(switchId)
                            .data(for: "switch", value: "bool")
                        Label().for(switchId)
                            .data(for: "onlabel", value: "Ja")
                            .data(for: "offlabel", value: "Nei")
                    }
                    TableCell {
                        Button {
                            Italic().class("mdi mdi-delete")
                        }
                        .type(.button)
                        .class("btn btn-danger btn-rounded")
                        .on(click: "deleteChoise(-" + choise.id + ");")
                    }
                }
                .id("choise--" + choise.id)

            }
        }
    }
}
