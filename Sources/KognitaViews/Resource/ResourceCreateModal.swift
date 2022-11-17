//
//  ResourceCreateModal.swift
//  
//
//  Created by Mats Mollestad on 15/01/2021.
//

import Foundation

struct ResourceCreateModal: HTMLComponent {
    
    static let modalID = "create-resource-modal"
    
    enum ConnectionType: String {
        case subtopic
        case term
    }
    
    static func button(inputName: HTML, formName: HTML) -> Button {
        Button {
            "Legg til en ressurs"
            MaterialDesignIcon(.multipleNotes)
                .margin(.one, for: .left)
        }
        .button(style: .light)
        .toggle(modal: .id(ResourceCreateModal.modalID))
        .data("input-name", value: inputName)
        .data("form-name", value: formName)
    }
    
    static func button(connectionType: ConnectionType, connectionID: HTML) -> Button {
        Button {
            "Legg til en ressurs"
            MaterialDesignIcon(.multipleNotes)
                .margin(.one, for: .left)
        }
        .button(style: .light)
        .toggle(modal: .id(ResourceCreateModal.modalID))
        .data("con-type", value: connectionType.rawValue)
        .data("con-id", value: connectionID)
    }
    
    enum Mode {
        case connection
        case uncreated
    }
    
    let mode: Mode
    
    var body: HTML {
        switch mode {
        case .uncreated:
            return baseModel
                .set(data: "input-name", type: .input, to: "resource-input-name")
                .set(data: "form-name", type: .input, to: "resource-form-name")
        case .connection:
            return baseModel
                .set(data: "con-type", type: .input, to: "resource-connect-type")
                .set(data: "con-id", type: .input, to: "resource-connect-id")
        }
    }
    
    var baseModel: Modal {
        Modal(title: "Registrer en ressurs", id: ResourceCreateModal.modalID) {
            
            Form {
                FormGroup(label: "Tittel") {
                    Input().type(.text)
                        .id("resource-title")
                        .placeholder("SQL, Logical address")
                        .required()
                }
                .invalidFeedback {
                    "Må skrive en tittel"
                }
                
                IF(mode == .uncreated) {
                    Input().type(.hidden).id("resource-input-name")
                    Input().type(.hidden).id("resource-form-name")
                }.else {
                    Input().type(.hidden).id("resource-connect-id")
                    Input().type(.hidden).id("resource-connect-type")
                }
                
                Tabs()
                    .selected(id: "article-rec")
                    .add(tabID: "article-rec", icon: .fileDocument, label: "Article") {
                        FormGroup(label: "URL") {
                            Input()
                                .type(.url)
                                .id("article-url")
                                .placeholder("https://web.dev/why-https-matters/")
                                .required()
                        }
                        .invalidFeedback {
                            "Må skrive en url"
                        }
                        
                        FormGroup(label: "Forfatter") {
                            Input()
                                .type(.text)
                                .id("article-author")
                                .placeholder("Kayce Basques")
                                .required()
                        }
                        .invalidFeedback {
                            "Må skrive en forfatter"
                        }
                    }
                    .add(tabID: "video-rec", icon: .video, label: "Video") {
                        FormGroup(label: "URL") {
                            Input()
                                .type(.url)
                                .id("video-url")
                                .placeholder("https://www.youtube.com/watch?v=spUNpyF58BY")
                                .required()
                        }
                        .invalidFeedback {
                            "Må skrive en url"
                        }
                        
                        FormGroup(label: "Produsent") {
                            Input()
                                .type(.text)
                                .id("video-creator")
                                .placeholder("3Blue1Brown")
                                .required()
                        }
                        .invalidFeedback {
                            "Må skrive en produsent"
                        }
                        
                        FormGroup(label: "Lengde") {
                            Input()
                                .type(.number)
                                .id("video-duration")
                                .placeholder("19:31")
                        }
                    }
//                    .add(tabID: "book-rec", icon: .openBook, label: "Bok") {
//                        FormGroup(label: "Bok tittel") {
//                            Input()
//                                .type(.text)
//                                .id("book-title")
//                                .placeholder("Cryptography, An Introduction : Third Edition")
//                                .required()
//                        }
//                        .invalidFeedback {
//                            "Må skrive en bok tittel"
//                        }
//
//                        FormGroup(label: "Forfatter") {
//                            Input()
//                                .type(.text)
//                                .id("book-author")
//                                .placeholder("Springer International Publishing")
//                                .required()
//                        }
//                        .invalidFeedback {
//                            "Må skrive en forfatter"
//                        }
//
//                        Row {
//                            Div {
//                                FormGroup(label: "Start page") {
//                                    Input()
//                                        .type(.number)
//                                        .id("book-start-page")
//                                        .placeholder("33")
//                                }
//                            }
//                            .column(width: .six, for: .large)
//
//                            Div {
//                                FormGroup(label: "End page") {
//                                    Input()
//                                        .type(.number)
//                                        .id("book-end-page")
//                                        .placeholder("40")
//                                }
//                            }
//                            .column(width: .six, for: .large)
//                        }
//                    }
                
                Button {
                    MaterialDesignIcon(.check)
                        .margin(.one, for: .right)
                    "Lagre"
                }
                .type(.button)
                .button(style: .success)
                .on(click: "createResource()")
            }
            .id("resource-form")
            .class("needs-validation")
            .add(.init(attribute: "novalidate", value: nil))
        }
    }
    
    var scripts: HTML {
        NodeList {
            body.scripts
            Script(source: "/assets/js/resources/create.js")
        }
    }
}
