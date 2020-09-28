@_exported import BootstrapKit
import Foundation

public struct KognitaViews {

    public static func renderer(rootURL: String, renderer: HTMLRenderer) throws {

        renderer.timeZone = TimeZone(abbreviation: "CET") ?? renderer.timeZone

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
        try renderer.add(view: User.Templates.ResetPassword.Mail(rootUrl: rootURL))
        try renderer.add(view: User.Templates.ResetPassword.Reset())
        try renderer.add(view: User.Templates.VerifyMail(rootUrl: rootURL))
        try renderer.add(view: User.Templates.VerifiedConfirmation())
        try renderer.add(view: User.Templates.Profile())

        // Main User pages
        try renderer.add(view: Subject.Templates.ListOverview())
        try renderer.add(view: Subject.Templates.Details())
        try renderer.add(view: Subject.Templates.TaskList())
        try renderer.add(view: Subject.Templates.Compendium())

        try renderer.add(view: SubjectTest.Templates.Modify())
        try renderer.add(view: SubjectTest.Templates.List())
        try renderer.add(view: SubjectTest.Templates.Monitor())
        try renderer.add(view: SubjectTest.Templates.StatusSection())
        try renderer.add(view: SubjectTest.Templates.Results())

        try renderer.add(view: TestSession.Templates.Overview())
        try renderer.add(view: TestSession.Templates.Results())
        try renderer.add(view: TestSession.Templates.TaskResult())

    //    // Task Overview
    //    try renderer.add(template: TaskOverviewListTemplate())

    //    // Task Template
        try renderer.add(view: TypingTask.Templates.Execute())
        try renderer.add(view: MultipleChoiceTask.Templates.Execute())
        try renderer.add(view: TaskPreviewTemplate.Responses())
        try renderer.add(view: TaskSolution.Templates.List())
        try renderer.add(view: MultipleChoiseTaskTestMode())
        try renderer.add(view: TaskDiscussion.Templates.DiscussionCard())
        try renderer.add(view: TaskDiscussion.Templates.UserDiscussions())

    //
    //    // Create Content
        try renderer.add(view: Subject.Templates.Create())
        try renderer.add(view: Topic.Templates.Create())
        try renderer.add(view: Topic.Templates.Modify())
        try renderer.add(view: Subtopic.Templates.Create())
    //
    //    // Create Task Templates
        try renderer.add(view: TypingTask.Templates.Create())
        try renderer.add(view: TypingTask.Templates.CreateDraft())
        try renderer.add(view: MultipleChoiceTask.Templates.Create())
//        try renderer.add(view: MultipleChoiceTask.Templates.ImportQTI())
    //
    //    // Practice Session
        try renderer.add(view: PracticeSession.Templates.Result())
        try renderer.add(view: Sessions.Templates.History())

    //    // Creator pages
        try renderer.add(view: Subject.Templates.ContentOverview())
    //    try renderer.add(template: CreatorInformationPage())
    }
}
