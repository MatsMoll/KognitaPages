import BootstrapKit
import KognitaCore

extension AttributeNode {
    func dismissModal() -> Self {
        self.data("dismiss", value: "modal")
    }
}

struct TaskDiscussionCard: HTMLComponent {

    var scripts: HTML {
        NodeList {
            Script(source: "/assets/js/task-discussion/create.js")
            Script(source: "/assets/js/task-discussion/create-response.js")
            Script(source: "/assets/js/task-discussion/fetch-discussions.js")
            body.scripts
        }
    }

    var body: HTML {
        NodeList {
            Div().id("discussions").display(.none)
            TaskDiscussion.Templates.CreateModal()
        }
    }
}

struct TaskSolutionCard: HTMLComponent {

    var scripts: HTML {
        NodeList {
            Script(source: "/assets/js/task-solution/vote.js")
            Script(source: "/assets/js/task-solution/suggest-solution.js")
            Script {
"""
function fetchSolutions() {
    let sessionType = window.location.pathname.split('/')[1];
    fetch("/" + sessionType + "/" + sessionID() + "/tasks/" + taskIndex() + "/solutions", {
        method: "GET",
        headers: {
            "Accept": "application/html, text/plain, */*",
        }
    })
    .then(function (response) {
        if (response.ok) {
            return response.text();
        } else {
            throw new Error(response.statusText);
        }
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
function sessionID() {
    let path = window.location.pathname;
    let splitURI = "sessions/"
    return parseInt(path.substring(
        path.indexOf(splitURI) + splitURI.length,
        path.lastIndexOf("/tasks")
    ));
}
function taskIndex() {
    let path = window.location.pathname;
    let splitURI = "tasks/";
    return parseInt(path.substring(
        path.indexOf(splitURI) + splitURI.length,
        path.length
    ));
}
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
.catch(function (error) {$("#submitButton").attr("disabled", false);$("#error-massage").text(error.message);$("#error-div").fadeIn();$("#error-div").removeClass("d-none");
});
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
.catch(function (error) {$("#submitButton").attr("disabled", false);$("#error-massage").text(error.message);$("#error-div").fadeIn();$("#error-div").removeClass("d-none");
});
}
"""
            }
            body.scripts
        }
    }

    var body: HTML {
        NodeList {
            Div().id("solution").display(.none)
            CreateModal()
            EditModal()
            DeleteModal()
        }
    }
}

extension TaskSolutionCard {

    struct CreateModal: HTMLComponent {

        var body: HTML {
            Modal(title: "Lag et løsningsforslag", id: "create-alternative-solution") {

                CustomControlInput(
                    label: "Vis brukernavnet",
                    type: .checkbox,
                    id: "present-user"
                )
                    .isChecked(true)
                    .margin(.two, for: .bottom)

                FormGroup(label: "Løsningsforslag") {
                    MarkdownEditor(id: "suggested-solution")
                        .placeholder("Et eller annet løsningsforslag")
                        .onChange { editor in
                            Script.solutionScore(divID: "new-solution-req", editorName: editor)
                    }
                }
                .description { TaskSolution.Templates.Requmendations().id("new-solution-req") }
                .margin(.four, for: .bottom)

                Button { "Lag løsningsforslag" }
                    .on(click: "suggestSolution()")
                    .button(style: .primary)
            }
        }
    }

    struct EditModal: HTMLComponent {

        var body: HTML {
            Modal(title: "Rediger et løsningsforslag", id: "edit-solution") {

                Input().type(.hidden).id("edit-solution-id")

                FormGroup(label: "Løsningsforslag") {
                    MarkdownEditor(id: "updated-solution")
                        .placeholder("Et eller annet løsningsforslag")
                        .onChange { editor in
                            Script.solutionScore(divID: "update-solution-req", editorName: editor)
                    }
                }
                .description { TaskSolution.Templates.Requmendations().id("update-solution-req") }
                .margin(.four, for: .bottom)

                Button { "Lagre løsningsforslag" }
                    .on(click: "saveSolution()")
                    .button(style: .primary)
            }
            .set(data: "markdown", type: .markdown, to: "updated-solution")
            .set(data: "solutionID", type: .input, to: "edit-solution-id")
        }
    }

    struct DeleteModal: HTMLComponent {

        var body: HTML {
            Modal(title: "Slett løsningsforslag", id: "delete-solution") {

                Input().type(.hidden).id("delete-solution-id")

                Text { "Er du sikker på at du vil slette løsningsforslaget?" }.style(.heading4)

                Button {
                    MaterialDesignIcon(.delete)
                        .margin(.one, for: .right)
                    "Slett"
                }
                .on(click: "deleteSolution()")
                .button(style: .danger)

                Button {
                    MaterialDesignIcon(.close)
                        .margin(.one, for: .right)
                    "Avbryt"
                }
                .button(style: .primary)
                .margin(.one, for: .left)
                .dismissModal()
            }
            .set(data: "solutionID", type: .input, to: "delete-solution-id")
        }
    }
}

extension TestSession.DetailedTaskResult {

    var choiseContext: [MultipleChoiseTask.Templates.Execute.ChoiseContext] {
        choises.map {
            .init(choise: $0, selectedChoises: selectedChoises)
        }
    }
}

extension TestSession.Templates {

    public struct TaskResult: HTMLTemplate {

        public struct Context {
            let user: User
            let result: TestSession.DetailedTaskResult

            var testResultUri: String {
                "/test-sessions/\(result.testSessionID)/results"
            }

            public init(user: User, result: TestSession.DetailedTaskResult) {
                self.user = user
                self.result = result
            }
        }

        var breadcrumbs: [BreadcrumbItem] {
            [
                BreadcrumbItem(link: "/practice-sessions/history", title: "Historikk"),
                BreadcrumbItem(link: ViewWrapper(view: context.testResultUri), title: "Prøve")
            ]
        }

        public var body: HTML {
            ContentBaseTemplate(
                userContext: context.user,
                baseContext: .constant(.init(title: "Resultat", description: "Resultat"))
            ) {
                PageTitle(title: "Resultat", breadcrumbs: breadcrumbs)

                Input().type(.hidden).value(context.result.taskID).id("task-id")

                Row {
                    Div {
                        TaskPreviewTemplate.QuestionCard(
                            description: context.result.description,
                            question: context.result.question
                        )

                        Card {

                            Text { "Alternativene" }
                                .style(.heading5)
                                .margin(.zero, for: .top)

                            ForEach(in: context.result.choiseContext) { (choise: TemplateValue<MultipleChoiseTask.Templates.Execute.ChoiseContext>) in
                                MultipleChoiseTask.Templates.Execute.ChoiseOption(
                                    hasBeenAnswered: true,
                                    canSelectMultiple: context.result.isMultipleSelect,
                                    choise: choise
                                )
                            }
                        }
                    }
                    .column(width: .seven)
                    Div {
                        TaskSolutionCard()
                        TaskDiscussionCard()
                    }
                    .column(width: .five)
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
                Script {
"""
window.onload=function() {fetchSolutions();fetchDiscussions($("#task-id").val());};
"""
                }
            }
        }
    }
}
