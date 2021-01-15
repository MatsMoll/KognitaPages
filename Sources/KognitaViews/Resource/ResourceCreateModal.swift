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
    
    var body: HTML {
        Modal(title: "Registrer en ressurs", id: ResourceCreateModal.modalID) {
            
            FormGroup(label: "Tittel") {
                Input().type(.text).id("resource-title")
                    .placeholder("SQL, Logical address")
            }
            
            Input().type(.hidden).id("resource-connect-id")
            Input().type(.hidden).id("resource-connect-type")
            
            Tabs()
                .selected(id: "article-rec")
                .add(tabID: "article-rec", icon: .fileDocument, label: "Article") {
                    FormGroup(label: "URL") {
                        Input()
                            .type(.url)
                            .id("article-url")
                            .placeholder("https://web.dev/why-https-matters/")
                    }
                    
                    FormGroup(label: "Forfatter") {
                        Input()
                            .type(.text)
                            .id("article-author")
                            .placeholder("Kayce Basques")
                    }
                }
                .add(tabID: "video-rec", icon: .video, label: "Video") {
                    FormGroup(label: "URL") {
                        Input()
                            .type(.url)
                            .id("video-url")
                            .placeholder("https://www.youtube.com/watch?v=spUNpyF58BY")
                    }
                    
                    FormGroup(label: "Produsent") {
                        Input()
                            .type(.text)
                            .id("video-creator")
                            .placeholder("3Blue1Brown")
                    }
                    
                    FormGroup(label: "Lengde") {
                        Input()
                            .type(.number)
                            .id("video-duration")
                            .placeholder("19:31")
                    }
                }
                .add(tabID: "book-rec", icon: .openBook, label: "Bok") {
                    FormGroup(label: "Bok tittel") {
                        Input()
                            .type(.text)
                            .id("book-title")
                            .placeholder("Cryptography, An Introduction : Third Edition")
                    }
                    
                    FormGroup(label: "Forfatter") {
                        Input()
                            .type(.text)
                            .id("book-author")
                            .placeholder("Springer International Publishing")
                    }
                    
                    Row {
                        Div {
                            FormGroup(label: "Start page") {
                                Input()
                                    .type(.number)
                                    .id("book-start-page")
                                    .placeholder("33")
                            }
                        }
                        .column(width: .six, for: .large)
                        
                        Div {
                            FormGroup(label: "End page") {
                                Input()
                                    .type(.number)
                                    .id("book-end-page")
                                    .placeholder("40")
                            }
                        }
                        .column(width: .six, for: .large)
                    }
                }
            
            Button {
                "Lagre"
                MaterialDesignIcon(.check)
                    .margin(.one, for: .left)
            }
            .button(style: .success)
            .on(click: "createResource()")
            .dismissModal()
        }
        .set(data: "con-type", type: .input, to: "resource-connect-type")
        .set(data: "con-id", type: .input, to: "resource-connect-id")
    }
    
    var scripts: HTML {
        NodeList {
            body.scripts
            Script(source: "/assets/js/resources/create.js")
        }
    }
}
