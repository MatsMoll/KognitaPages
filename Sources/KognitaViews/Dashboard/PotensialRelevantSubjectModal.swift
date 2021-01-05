//
//  File.swift
//  
//
//  Created by Mats Mollestad on 21/12/2020.
//

import BootstrapKit

struct PotensialRelevantSubjectModal: HTMLComponent {
    
    static let modalID = "rel-subject-modal"
    
    let activeSubjects: TemplateValue<[User.FeideSubject]>
    let inactiveSubjects: TemplateValue<[User.FeideSubject]>
    
    var body: HTML {
        Modal(title: "Relevante emner", id: PotensialRelevantSubjectModal.modalID) {
            
            Text { "Vi fant noen temaer som kan være relevante for deg" }
            
            ForEach(in: activeSubjects) { subject in
                SubjectRow(subject: subject, isChecked: true)
            }
            
            Text { "Inaktive emner" }
            
            ForEach(in: inactiveSubjects) { subject in
                SubjectRow(subject: subject, isChecked: false)
            }
            
            Button { "Lagre" }
                .button(style: .success)
                .margin(.one, for: .right)
                .on(click: "markPotensialSubjects()")
            
            Button { "Senere" }
                .button(style: .light)
                .dismissModal()
        }
    }
    
    var scripts: HTML {
        NodeList {
            body.scripts
            Script(source: "/assets/js/subject/mark-potensial.js")
        }
    }
    
    struct SubjectRow: HTMLComponent {
        
        let subject: TemplateValue<User.FeideSubject>
        let isChecked: Conditionable
        
        var body: HTML {
            Card {
                Switch(id: subject.id, isChecked: isChecked, onText: "Bruk")
                    .class("rel-switch")
                    .float(.right)
                
                Text {
                    subject.code
                    ": "
                    subject.name
                }
                .style(.cardTitle)
                
                Text {
                    "Rolle: "
                    subject.role
                }
                .style(.cardText)
            }
            .class("shadow-none border")
        }
    }
}

struct Switch: HTMLComponent, AttributeNode {
    
    let onText: HTML
    let offText: HTML
    let id: HTML
    let isChecked: Conditionable
    var attributes: [HTMLAttribute]
    
    init(id: HTML, isChecked: Conditionable = false, onText: HTML = "", offText: HTML = "") {
        self.id = id
        self.isChecked = isChecked
        self.onText = onText
        self.offText = offText
        self.attributes = []
    }
    
    private init(id: HTML, isChecked: Conditionable, onText: HTML, offText: HTML, attributes: [HTMLAttribute]) {
        self.id = id
        self.isChecked = isChecked
        self.onText = onText
        self.offText = offText
        self.attributes = attributes
    }
    
    var body: HTML {
        Div {
            Input().type(.checkbox).data("switch", value: "bool").id(id).isChecked(isChecked)
            Label().data("on-label", value: onText).data("off-label", value: offText).for(id)
        }
        .add(attributes: attributes)
    }
    
    func copy(with attributes: [HTMLAttribute]) -> Switch {
        .init(id: id, isChecked: isChecked, onText: onText, offText: offText, attributes: attributes)
    }
}
