//
//  CreateNewExamModal.swift
//  KognitaViews
//
//  Created by Mats Mollestad on 05/11/2020.
//

import Foundation

extension Exam {
    enum Templates {
        struct CreateNewModal: HTMLComponent {

            static let identifier = "create-new-exam-modal"

            var selectorID: String
            let subjectID: TemplateValue<Subject.ID>

            var body: HTML {
                Modal(title: "Registrer Ny Eksamen", id: CreateNewModal.identifier) {

                    Label { "Eksamenstype" }

                    CustomControlInput(label: "Orginal", type: .radio, id: "original-exam-type", name: "exam-type", value: ExamType.original.rawValue)
                    CustomControlInput(label: "Konte", type: .radio, id: "continuation-exam-type", name: "exam-type", value: ExamType.continuation.rawValue)

                    FormGroup(label: "År") {
                        Input()
                            .type(.number)
                            .min(value: 2000)
                            .max(value: 2021)
                            .placeholder(2019)
                            .id("exam-year")
                    }
                    .margin(.three, for: .top)

                    Button { "Registrer" }
                        .on(click: "saveExam()")
                        .button(style: .success)
                        .type(.button)
                }
            }

            var scripts: HTML {
                Script {
"""
function examJsonData() {
return new Promise(function (resolve, reject) {
let examType = $('input[name=exam-type]:checked').val();
let year = parseInt($("#exam-year").val());

if (isNaN(year) || year < 2000) {
    reject(Error("Du må skrive inn et år"));
}
resolve(JSON.stringify({
    "year" : year,
    "type" : examType,
    "subjectID" :
""".trimmingCharacters(in: .newlines) + subjectID +
"""
,
}))
})
}

function saveExam() {
    examJsonData().then(function (jsonData){
        fetch("/api/exams", {
            method: "POST",
            headers: {
                "Accept": "application/json, text/plain, */*",
                "Content-Type" : "application/json"
            },
            body: jsonData
        })
        .then(function (response) {
            if (response.ok) {
                return response.json();
            } else if (response.status == 400) {
                throw new Error("Sjekk at all nødvendig info er fylt ut");
            } else {
                throw new Error(response.statusText);
            }
        })
        .then(function (json) {
var name = "År " + json["year"];
if (json["type"] == "original") { name += " orginal" } else { name += " konte" }
var newExam = new Option(name, json["id"], true, true);
$("#\(selectorID)").append(newExam).trigger("change");
$("#\(CreateNewModal.identifier)").modal("toggle");
})
})
.catch(function (error) {
presentErrorMessage(error.message);
});
}
""".trimmingCharacters(in: .newlines)
                }
            }
        }
    }
}
