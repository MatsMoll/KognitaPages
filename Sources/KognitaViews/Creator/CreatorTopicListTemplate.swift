//
//  CreatorTopicListTemplate.swift
//  App
//
//  Created by Mats Mollestad on 27/03/2019.
//

import HTMLKit
import KognitaCore

public class CreatorTopicListTemplate: LocalizedTemplate {

    public init() {}

    public static var localePath: KeyPath<CreatorTopicListTemplate.Context, String>? = \.locale

    public enum LocalizationKeys: String {
        case none
    }

    public struct Context {
        let locale = "nb"
        let subjects: [Subject]
        let topics: [Topic]
    }

    public func build() -> CompiledTemplate {
        return ContentBaseTemplate(
            body:

            div.class("row").child(

                div.class("col-12").child(

                    h3.class("mb-2").child(
                        "Dine oppgaver"
                    ),

                    div.class("card").child(
                        div.class("card-body").child(

                            a.href("/subjects/topic").child(
                                button.class("btn btn-primary").child(
                                    "Lag et tema"
                                )
                            ),

                            renderIf(
                                \.topics.count > 0,

                                div.class("table-responsive").child(
                                    table.class("table table-centered w-100 dt-responsive nowrap").id("products-datatable").child(
                                        thead.class("thead-light").child(
                                            tr.child(
                                                th.class("all").style("width: 20px;").child(
                                                    div.class("custom-control custom-checkbox").child(
                                                        input.type("checkbox").class("custom-control-input").id("customCheck1"),
                                                        label.class("custom-control-label").for("customCheck1").child(
                                                            " "
                                                        )
                                                    )
                                                ),
                                                th.class("all").child(
                                                    "Fag"
                                                ),
                                                th.child(
                                                    "Tema"
                                                ),
                                                th.child(
                                                    "Spørsmål"
                                                ),
                                                th.child(
                                                    "Status"
                                                ),
                                                th.child(
                                                    "Handlinger"
                                                )
                                            )
                                        )
                                    )
                                )
                            ).else(
                                div.class("col-12").child(
                                    h3.child("text-center").child(
                                        "Du har ikke laget noen oppgaver enda."
                                    )
                                )
                            )
                        )
                    )
                )
            )
        )
    }
}
