import BootstrapKit
import KognitaCore

extension TaskSolution.Unverified {
    fileprivate var approveButtonID: String { "solution-\(solutionID)" }
    fileprivate var approveDivID: String { "solution-div-\(solutionID)" }
    fileprivate var approveCall: String { "approveSolution(\(solutionID))" }
}

extension TaskSolution.Templates {

    public struct UnverifiedList: HTMLComponent {

        let solutions: TemplateValue<[TaskSolution.Unverified]>

        public var body: HTML {
            ForEach(in: solutions) { (solution: TemplateValue<TaskSolution.Unverified>) in
                Div {
                    Unwrap(solution.description) { (description: TemplateValue<String>) in
                        Text { description.escaping(.unsafeNone) }
                            .class("render-markdown")
                    }
                    Text { solution.question }
                        .style(.heading4)

                    IF(solution.choises.isEmpty == false) {
                        Text { "Valg:" }
                            .font(style: .italic)

                        ForEach(in: solution.choises) { choise in
                            Div {
                                Text {
                                    IF(choise.isCorrect) {
                                        Badge {
                                            "Riktig "
                                            MaterialDesignIcon(.check)
                                        }
                                        .background(color: .success)
                                        .float(.right)
                                    }

                                    Div { choise.choise.escaping(.unsafeNone) }
                                        .class("render-markdown")
                                }
                            }
                            .borderRadius(.rounded)
                            .border(color: .light)
                            .margin(.one, for: .vertical)
                            .padding(.two)
                        }
                    }

                    Text { "Løsningen: " }
                        .font(style: .italic)
                        .margin(.three, for: .top)

                    Text { solution.solution.escaping(.unsafeNone) }
                        .class("render-markdown")

                    Button { "Godkjenn" }
                        .button(style: .primary)
                        .id(solution.approveButtonID)
                        .on(click: solution.approveCall)

//                    Button { "Rediger" }
//                        .button(style: .light)
//                        .margin(.one, for: .left)
                }
                .id(solution.approveDivID)
                .class("border-bottom border-light")
                .padding(.three, for: .vertical)
            }
        }

        public var scripts: HTML {
            NodeList {
                Script(source: "/assets/js/vendor/marked.min.js")
                Script(source: "/assets/js/vendor/katex.min.js")
                Script(source: "/assets/js/markdown-renderer.js")
                Script {
"""
function approveSolution(id) {
    let url = "/api/task-solutions/" + id + "/approve"
    fetch(url, { method: "POST", headers: { "Accept": "application/json, text/plain, */*", "Content-Type" : "application/json" } }).then(function (response) {
        if (response.ok) {
            $("#solution-" + id).removeClass("btn-primary");
            $("#solution-" + id).addClass("btn-success");
            $("#solution-" + id).html("Godkjent <i class='mdi mdi-check ml-1'/>");
            $("#solution-" + id).prop("disabled", true);
            setTimeout(function (){ $("#solution-div-" + id).fadeOut(300, function () { $(this).remove() }) }, 500);
        } else { console.log("Error: ", response.statusText); }
    })
}
"""
                }
            }
        }
    }
}
