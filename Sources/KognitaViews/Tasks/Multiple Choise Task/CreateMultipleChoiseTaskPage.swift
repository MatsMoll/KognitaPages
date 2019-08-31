//
//  CreateMultipleChoiseTaskPage.swift
//  App
//
//  Created by Mats Mollestad on 27/02/2019.
//

import HTMLKit
import KognitaCore

extension AttributableNode {
    func dataSwitch(_ value: CompiledTemplate...) -> Self {
        return add(.init(attribute: "data-switch", value: value))
    }

    func dataOnLabel(_ value: CompiledTemplate...) -> Self {
        return add(.init(attribute: "data-on-label", value: value))
    }

    func dataOffLabel(_ value: CompiledTemplate...) -> Self {
        return add(.init(attribute: "data-off-label", value: value))
    }
}


public struct CreateMultipleChoiseTaskPage: LocalizedTemplate {

    public init() {}

    public static var localePath: KeyPath<CreateMultipleChoiseTaskPage.Context, String>? = \.locale

    public enum LocalizationKeys: String {
        case none
    }

    public struct Context {
        let locale = "nb"
        let base: ContentBaseTemplate.Context
        let subject: Subject
        let topics: SubtopicPicker.Context

        // Used to edit a task
        let taskInfo: Task?
        let multipleTaskInfo: MultipleChoiseTask.Data?

        public init(user: User, subject: Subject, topics: [Topic.Response], taskInfo: Task? = nil, multipleTaskInfo: MultipleChoiseTask.Data? = nil, selectedTopicId: Int? = nil) {
            self.base = .init(user: user, title: "Lag oppgave")
            self.subject = subject
            let sortSelectedTopicId = selectedTopicId ?? taskInfo?.subtopicId
            self.topics = .init(topics: topics, selectedSubtopicId: sortSelectedTopicId)
            self.taskInfo = taskInfo
            self.multipleTaskInfo = multipleTaskInfo
        }
    }

    public func build() -> CompiledTemplate {
        return embed(
            ContentBaseTemplate(
                body:
                div.class("pt-5").child(
                    div.class("card").child(
                        div.class("modal-header text-white bg-" + variable(\.subject.colorClass.rawValue)).child(
                            h4.class("modal-title").id("create-modal-label").child(
                                variable(\.subject.name), " | Lag flervalgs oppgave"
                            )
                        ),
                        div.class("modal-body").child(
                            div.class("p-2").child(
                                form.class("needs-validation").novalidate.child(

                                    // Topic
                                    embed(
                                        SubtopicPicker(idPrefix: "create-multiple-"),
                                        withPath: \.topics
                                    ),

                                    renderIf(
                                        isNotNil: \.taskInfo,

                                        renderIf(
                                            \.taskInfo?.deletedAt != nil,

                                            div.class("badge badge-danger").child(
                                                "Inaktiv"
                                            )
                                        ).else(
                                            div.class("badge badge-success").child(
                                                "Godkjent"
                                            )
                                        )
                                    ),

                                    // Exam Paper
                                    div.class("form-row").child(
                                        div.class("form-group col-md-6").child(
                                            label.for("create-multiple-exam-semester").class("col-form-label").child(
                                                "Eksamensett semester"
                                            ),

                                            select.id("create-multiple-exam-semester").class("select2 form-control select2").dataToggle("select2").dataPlaceholder("Velg ...").required.child(
                                                renderIf(
                                                    isNotNil: \Context.taskInfo?.examPaperSemester,

                                                    option.value(variable(\.taskInfo?.examPaperSemester?.rawValue)).selected.child(
                                                        variable(\.taskInfo?.examPaperSemester?.rawValue)
                                                    )
                                                ),
                                                option.value("").child(
                                                    "Ikke eksamensoppgave"
                                                ),
                                                option.value("fall").child(
                                                    "Høst"
                                                ),
                                                option.value("spring").child(
                                                    "Vår"
                                                )
                                            )
                                        ),

                                        div.class("form-group col-md-6").child(
                                            label.for("create-multiple-exam-year").class("col-form-label").child(
                                                "År"
                                            ),
                                            input.type("number").class("form-control").id("create-multiple-exam-year").placeholder("2019").value(variable(\.taskInfo?.examPaperYear)).required
                                        )
                                    ),

                                    // Is Examinable
                                    div.class("custom-control custom-checkbox mt-3").child(
                                        input.type("checkbox").class("custom-control-input").id("create-multiple-examinable").checked,
                                        label.for("create-multiple-examinable").class("custom-control-label").child(
                                            "Bruk på prøver"
                                        )
                                    ),

                                    // Description
                                    div.class("form-group").child(
                                        label.for("create-multiple-description").class("col-form-label").child(
                                            "Oppgavetekst"
                                        ),
                                        div.id("create-multiple-description").child(
                                            variable(\.taskInfo?.description, escaping: .unsafeNone)
                                        )
                                    ),

                                    // Question
                                    div.class("form-group").child(
                                        label.for("create-multiple-question").class("col-form-label").child(
                                            "Spørsmål"
                                        ),
                                        textarea.class("form-control").id("create-multiple-question").rows(1).placeholder("Noe å svare på her").required.child(
                                            variable(\.taskInfo?.question)
                                        ),
                                        div.class("invalid-feedback").child(
                                            "Bare lov med store og små bokstaver, tall, mellomrom + (. , : ; !, ?)"
                                        )
                                    ),

                                    // Solution
                                    div.class("form-group").child(
                                        label.for("create-multiple-solution").class("col-form-label").child(
                                            "Løsning"
                                        ),
                                        div.id("create-multiple-solution").child(
                                            variable(\.taskInfo?.solution, escaping: .unsafeNone)
                                        )
                                    ),

                                    // Is multiple select
                                    div.class("custom-control custom-checkbox mt-3").child(
                                        input.type("checkbox").class("custom-control-input").id("create-multiple-select").if(\.multipleTaskInfo?.isMultipleSelect == true, add: .checked),
                                        label.class("custom-control-label").for("create-multiple-select").child(
                                            "Kan velge fler enn et svar"
                                        )
                                    ),

                                    // Choises add input
                                    div.class("form-row mt-2 mb-2").child(
                                        div.class("form-group col-md-10").child(
                                            label.for("create-multiple-choise").class("col-form-label").child(
                                                "Legg til et valg"
                                            ),
                                            div.id("create-multiple-choise")
                                        ),
                                        div.class("form-group col-md-2").child(
                                            button.type("button").class("btn btn-success btn-rounded").onclick("addChoise();").child(
                                                "+"
                                            )
                                        )
                                    ),

                                    // Choises list
                                    div.class("form-group").child(
                                        table.class("col-12").child(
                                            thead.child(
                                                tr.child(
                                                    th.child(
                                                        "Valg"
                                                    ),
                                                    th.child(
                                                        "Er riktig"
                                                    ),
                                                    th.child(
                                                        "Handlinger"
                                                    )
                                                )
                                            ),
                                            tbody.id("create-multiple-choises").child(

                                                renderIf(
                                                    isNotNil: \.multipleTaskInfo,

                                                    forEach(in:     \.multipleTaskInfo!.choises,
                                                            render: ChoiseRow()
                                                    )
                                                )
                                            )
                                        )
                                    ),

                                    DismissableError(),

                                    button.type("button").onclick(
                                        renderIf(isNil: \.taskInfo, "createMultipleChoise();").else("editMultipleChoise();")
                                        ).class("btn btn-success mb-3 mt-3").child(
                                            i.class("mdi mdi-save"),
                                            " Lagre"
                                    )
                                )
                            )
                        )
                    )
                ),

                headerLinks: [
                    link.href("/assets/css/vendor/summernote-bs4.css").rel("stylesheet").type("text/css"),
                    link.href("https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0/katex.min.css").rel("stylesheet")
                ],

                scripts: [
                    script.src("/assets/js/vendor/summernote-bs4.min.js"),
                    script.src("https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0/katex.min.js"),
                    script.src("/assets/js/vendor/summernote-math.js"),
                    script.src("/assets/js/dismissable-error.js"),
                    script.src("/assets/js/multiple-choise/json-data.js"),

                    renderIf(
                        isNil: \Context.taskInfo,

                        script.src("/assets/js/multiple-choise/create.js")
                    ).else(
                        script.src("/assets/js/multiple-choise/edit.js")
                    )
                ]
            ),
            withPath: \Context.base)
    }

    // MARK: - Subviews

    struct TopicSelect: ContextualTemplate {

        struct Context {
            let topic: Topic
            let isSelected: Bool
        }

        func build() -> CompiledTemplate {
            return option.if(\.isSelected, add: .selected).value(variable(\.topic.id)).child(
                variable(\.topic.name)
            )
        }
    }

    struct ChoiseRow: ContextualTemplate {

        typealias Context = MultipleChoiseTaskChoise

        func build() -> CompiledTemplate {
            let switchId: [CompiledTemplate] = ["switch-", variable(\.id)]

            return
                tr.id("choise--", variable(\.id)).child(
                    td.child(
                        variable(\.choise, escaping: .unsafeNone)
                    ),
                    td.child(
                        input.type("checkbox").id(switchId).dataSwitch("bool").if(\.isCorrect, add: .checked),
                        label.for(switchId).dataOnLabel("Ja").dataOffLabel("Nei")
                    ),
                    td.child(
                        button.type("button").class("btn btn-danger btn-rounded").onclick("deleteChoise(-", variable(\.id), ");").child(
                            i.class("mdi mdi-delete")
                        )
                    )
            )
        }
    }
}
