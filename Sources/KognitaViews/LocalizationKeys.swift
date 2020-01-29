//
//  LocalizationKeys.swift
//  KognitaViews
//
//  Created by Mats Mollestad on 21/10/2019.
//

import HTMLKit

public class Strings {

    static let errorMessage = "error.message"
    static let menuRegister = "menu.register"
    static let menuLogin = "menu.login"
    static let menuSubjectList = "menu.overview"
    static let menuPracticeHistory = "menu.history"
    static let menuLogout = "menu.logout"

    static let loginTitle = "login.title"
    static let loginSubtitle = "login.subtitle"

    static let registerTitle = "register.title"
    static let registerSubtilte = "register.subtitle"

    static let registerUsernameTitle = "register.username.title"
    static let registerUsernamePlaceholder = "register.username.placeholder"

    static let registerConfirmPasswordTitle = "register.password.confirmation.title"
    static let registerConfirmPasswordPlaceholder = "register.password.confirmation.placeholder"

    static let registerTermsOfServiceTitle = "register.tos.description"
    static let registerTermsOfServiceLink = "register.tos.link"

    static let resetPasswordTitle = "reset.password.title"
    static let resetPasswordSubtitle = "reset.password.subtitle"
    static let resetPasswordButton = "reset.password.button"

    static let registerButton = "register.button"
    static let alreadyHaveUser = "register.already.user.description"

    static let mailTitle = "login.mail.title"
    static let mailPlaceholder = "login.mail.placeholder"

    static let passwordTitle = "login.password.title"
    static let passwordPlaceholder = "login.password.placeholder"

    static let forgottenPassword = "login.forgotpw.link"

    static let loginButton = "login.button"

    static let loginNoUserTitle = "login.no.user.title"
    static let loginNoUserLink = "login.no.user.link"

    static let footerAboutUs = "footer.about.us"
    static let footerHelp = "footer.help"
    static let footerContact = "footer.contact"

    static let starterPageTitle = "starter.page.title"
    static let starterPageDescription = "starter.page.description"
    static let starterPageMoreButton = "starter.page.more.button"
    static let copyright = "footer.copyright"

    static let subjectTitle = "subjects.title"
    static let subjectStartSession = "subject.session.start"
    static let subjectTopicListTitle = "subject.topics.title"
    static let subjectsNoTopics = "subject.topics.none"

    static let topicButton = "subject.topic.card.button"
    static let topicProgressTitle = "subject.topic.card.progress.title"

    static let repeatTitle = "subjects.repeat.title"
    static let subjectsTitle = "subjects.title"
    static let subjectsListTitle = "subjects.list.title"
    static let subjectsNoContent = "subjects.no.content"
    static let subjectExploreButton = "subjects.subject.card.button"

    static let subjectRepeatDescription = "subjects.repeat.description"
    static let subjectRepeatStart = "subjects.repeat.button"
    static let subjectRepeatDays = "result.repeat.days"

    static let exerciseMainTitle = "exercise.main.title"
    static let exerciseSessionProgressTitle = "exercise.progress.title"
    static let exerciseSessionProgressGoal = "exercise.progress.goal"
    static let exerciseSolutionTitle = "exercise.solution.title"
    static let exerciseProposedSolutionTitle = "exercise.solution.proposed.title"
    static let exerciseExam = "exercise.exam"
    static let exerciseAnswerButton = "exercise.answer.button"
    static let exerciseSolutionButton = "exercise.solution.button"
    static let exerciseNextButton = "exercise.next.button"
    static let exerciseStopSessionButton = "exercise.stop.button"

    static let historyTitle = "history.title"
    static let historyDateColumn = "history.summary.date"
    static let historyGoalColumn = "history.summary.goal"
    static let historyDurationColumn = "history.summary.duration"
    static let historyNoSessions = "history.summary.none"

    static let histogramTitle = "result.histogram.title"

    static let resultSummaryNumberOfTasks = "result.summary.task.amount"
    static let resultSummaryGoal = "result.summary.goal"
    static let resultSummaryDuration = "result.summary.duration"
    static let resultSummaryAccuracy = "result.summary.accuracy"

    static let resultSummaryTopicColumn = "result.summary.review.topic"
    static let resultSummaryQuestionColumn = "result.summary.review.question"
    static let resultSummaryResultColumn = "result.summary.review.result"
    static let resultSummaryRepeatColumn = "result.summary.review.repeat"
}

extension String {
    func localized() -> HTML {
        Localized(key: self)
    }
}
