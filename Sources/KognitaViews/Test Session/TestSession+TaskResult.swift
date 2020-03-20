import BootstrapKit
import KognitaCore

struct TaskDiscussionCard: HTMLComponent {

    var scripts: HTML {
        NodeList {
            Script(source: "/assets/js/task-discussion/create.js")
            Script(source: "/assets/js/task-discussion/create-response.js")
            Script(source: "/assets/js/task-discussion/fetch-discussions.js")
        }
    }

    var body: HTML {
        Div().id("discussions").display(.none)
    }
}

struct TaskSolutionCard: HTMLComponent {

    var scripts: HTML {
        NodeList {
            Script(source: "/assets/js/task-solution/vote.js")
            Script(source: "/assets/js/task-solution/suggest-solution.js")
            Script {
"""
function fetchSolutions(sessionType) {
    fetch("/" + sessionType + "-sessions/" + sessionID() + "/tasks/" + taskIndex() + "/solutions", {
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
"""
            }
        }
    }

    var body: HTML {
        Div().id("solution").display(.none)
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

                Script {
"""
window.onload=function() {
    fetchSolutions("test");
    fetchDiscussions($("#task-id").val());
};
"""
                }
            }
        }
    }
}
