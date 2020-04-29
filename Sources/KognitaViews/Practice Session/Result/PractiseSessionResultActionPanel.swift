import BootstrapKit
import KognitaCore

public struct PractiseSessionResultActionPanel: HTMLComponent {

    let context: TemplateValue<PracticeSession.Templates.Result.Context>

    public var body: HTML {
        NodeList {
            Card {
                Text {
                    "Vil du øve mer på dette?"
                }
                .style(.cardTitle)

                Button {
                    "Start ny øving"
                }
                .isRounded()
                .on(click: context.startPractiseSessionCall)
                .button(style: .primary)
                .margin(.two, for: .bottom)
            }

            Card {
                Text {
                    "Vil du gjøre noe annet i emnet?"
                }
                .style(.cardTitle)

                Anchor {
                    "Gå tilbake til faget"
                }
                .isRounded()
                .href(context.subject.subjectDetailUri)
                .button(style: .light)
                .margin(.two, for: .bottom)
            }

            Card {
                Text {
                    "Trenger du lesestoff?"
                }
                .style(.cardTitle)

                Anchor {
                    "Gå til kompendiumet"
                }
                .isRounded()
                .href(context.goToCompendium)
                .button(style: .light)
                .margin(.two, for: .bottom)
            }
        }
    }
}

extension PracticeSession.Templates.Result.Context {
    var startPractiseSessionCall: String {
        "startPracticeSessionWithTopicIDs(\(topicResults.map(\.topicId)), \(subject.id))"
    }

    var goToCompendium: String {
        "/subjects/\(subject.id)/compendium"
    }
}
