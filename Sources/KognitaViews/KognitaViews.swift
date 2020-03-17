import HTMLKit
import KognitaCore
import Vapor

public struct KognitaViews {

    public static func renderer(env: Environment) throws -> HTMLRenderer {

        var rootUrlVariable: String! = Environment.get("ROOT_URL")
        if env != .production {
            rootUrlVariable = "http://localhost:8080"
        }
        guard let rootUrl = rootUrlVariable else {
            fatalError("No Root URL is set")
        }

        let renderer = HTMLRenderer()

        // Starter
        try renderer.add(view: Pages.Landing())

        // Legal
        try renderer.add(view: Pages.PrivacyPolicy())
        try renderer.add(view: Pages.TermsOfService())

        // Error Pages
        try renderer.add(view: Pages.ServerError())
        try renderer.add(view: Pages.NotFoundError())

        // Auth
        try renderer.add(view: LoginPage())
        try renderer.add(view: User.Templates.Signup())
        try renderer.add(view: User.Templates.ResetPassword.Start())
        try renderer.add(view: User.Templates.ResetPassword.Mail(rootUrl: rootUrl))
        try renderer.add(view: User.Templates.ResetPassword.Reset())
        try renderer.add(view: User.Templates.VerifyMail(rootUrl: rootUrl))
        try renderer.add(view: User.Templates.VerifiedConfirmation())
        try renderer.add(view: User.Templates.Profile())

        // Main User pages
        try renderer.add(view: Subject.Templates.ListOverview())
        try renderer.add(view: Subject.Templates.Details())
        try renderer.add(view: Subject.Templates.SelectRedirect())
        try renderer.add(view: Subject.Templates.TaskList())

        try renderer.add(view: SubjectTest.Templates.Modify())
        try renderer.add(view: SubjectTest.Templates.List())
        try renderer.add(view: SubjectTest.Templates.Monitor())
        try renderer.add(view: SubjectTest.Templates.StatusSection())
        try renderer.add(view: SubjectTest.Templates.Results())

        try renderer.add(view: TestSession.Templates.Overview())
        try renderer.add(view: TestSession.Templates.Results())

    //    // Task Overview
    //    try renderer.add(template: TaskOverviewListTemplate())

    //    // Task Template
        try renderer.add(view: FlashCardTask.Templates.Execute())
        try renderer.add(view: MultipleChoiseTask.Templates.Execute())
        try renderer.add(view: TaskPreviewTemplate.Responses())
        try renderer.add(view: TaskSolution.Templates.List())
        try renderer.add(view: MultipleChoiseTaskTestMode())
        try renderer.add(view: TaskDiscussion.Templates.DiscussionCard())
    //
    //    // Create Content
        try renderer.add(view: Subject.Templates.Create())
        try renderer.add(view: Topic.Templates.Create())
        try renderer.add(view: Subtopic.Templates.Create())
    //
    //    // Create Task Templates
        try renderer.add(view: FlashCardTask.Templates.Create())
        try renderer.add(view: MultipleChoiseTask.Templates.Create())
    //
    //    // Practice Session
        try renderer.add(view: PracticeSession.Templates.History())
        try renderer.add(view: PracticeSession.Templates.Result())

    //    // Creator pages
        try renderer.add(view: Subject.Templates.ContentOverview())
    //    try renderer.add(template: CreatorInformationPage())
        return renderer
    }
}
