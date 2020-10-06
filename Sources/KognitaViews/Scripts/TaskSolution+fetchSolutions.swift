//
//  TaskSolution+fetchSolutions.swift
//  KognitaViews
//
//  Created by Mats Mollestad on 03/09/2020.
//

import BootstrapKit

extension Script {
    static let fetchSolutionSessionUrl = #""/" + window.location.pathname.split('/')[1] + "/" + sessionID() + "/tasks/" + taskIndex() + "/solutions""#
    static let fetchSolutionEditorUrl = #""/tasks/" + taskID() + "/solutions""#

    static func fetchSolutions(url: String) -> String {
        """
        function fetchSolutions() {
            fetch(\(url), {
                method: "GET",
                headers: {
                    "Accept": "application/html, text/plain, */*",
                }
            })
            .then(function (response) {
                if (response.ok) { return response.text(); } else { throw new Error(response.statusText); }
            })
            .then(function (html) {
                $("#solution").html(html);
                $("#solution").fadeIn();
                $("#solution").removeClass("d-none");
                $(".solutions").each(function () {
                    this.innerHTML = renderMarkdown(this.innerHTML);
                });
            })
            .catch(function (error) {
                $("#submitButton").attr("disabled", false);
                $("#error-massage").text(error.message);
                $("#error-div").fadeIn();
                $("#error-div").removeClass("d-none");
            });
        }
        """
    }

    static let saveSolution = """
function saveSolution() {
let solutionID = $("#edit-solution-id").val();
if (solutionID == 0 || isNaN(solutionID)) { return; }
let uri = "/api/task-solutions/" + solutionID;
let data = JSON.stringify({
"solution": updatedsolution.value()
})
fetch(uri, {
    method: "PUT",
    headers: {
        "Accept": "application/json, text/plain, */*",
        "Content-Type" : "application/json"
    },
    body: data
})
.then(function (response) {
if (response.ok) {
fetchSolutions();
$("#edit-solution").modal("hide");
} else {
throw new Error(response.statusText);
}
})
.catch(function (error) {$("#edit-solution-error-message").text(error.message);$("#edit-solution-error-div").fadeIn();$("#edit-solution-error-div").removeClass("d-none");});
}
function deleteSolution() {
let solutionID = $("#delete-solution-id").val();
if (solutionID == 0 || isNaN(solutionID)) { return; }
let uri = "/api/task-solutions/" + solutionID;
fetch(uri, {
    method: "DELETE",
    headers: {
        "Accept": "application/json, text/plain, */*",
        "Content-Type" : "application/json"
    }
})
.then(function (response) {
if (response.ok) {
fetchSolutions();
$("#delete-solution").modal("hide");
} else {
throw new Error(response.statusText);
}
})
.catch(function (error) {$("#delete-solution-error-message").text(error.message);$("#delete-solution-error-div").fadeIn();$("#delete-solution-error-div").removeClass("d-none");});
}
"""
}

extension Script {
    static let practiceSessionIDFromUri = """
function sessionID() {
    let path = window.location.pathname;
    let splitURI = "sessions/"
    return parseInt(path.substring(
        path.indexOf(splitURI) + splitURI.length,
        path.lastIndexOf("/tasks")
    ));
}
"""

    static let recapSessionIDFromUri = """
function sessionID() {
    let path = window.location.pathname;
    let splitURI = "lecture-note-recap/"
    return parseInt(path.substring(
        path.indexOf(splitURI) + splitURI.length,
        path.lastIndexOf("/tasks")
    ));
}
"""

    static let practiceSessionTaskIndexFromUri = """
function taskIndex() {
    let path = window.location.pathname;
    let splitURI = "tasks/";
    return parseInt(path.substring(
        path.indexOf(splitURI) + splitURI.length,
        path.length
    ));
}
"""

    static let recapSessionTaskIndexFromUri = """
function taskIndex() {
    let path = window.location.pathname;
    let splitURI = "tasks/";
    return parseInt(path.substring(
        path.indexOf(splitURI) + splitURI.length,
        path.length
    ));
}
"""
}
