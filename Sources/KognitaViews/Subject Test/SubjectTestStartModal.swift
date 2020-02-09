import KognitaCore
import BootstrapKit

extension SubjectTest {
    public enum Templates {}
}

extension SubjectTest.OverviewResponse {
    var enterUri: String {
        return "/subject-tests/\(id)/enter"
    }
}

extension SubjectTest.Templates {
    struct StartModal: HTMLComponent {

        let test: TemplateValue<SubjectTest.OverviewResponse>
        let wasIncorrectPassword: TemplateValue<Bool>

        var body: HTML {
            Modal(title: "Lag innhold", id: "start-subject-test-modal") {
                Text {
                    test.title
                }
                .style(.heading3)

                Form {
                    InputGroup {
                        Input()
                            .type(.password)
                            .id("password")
                            .name("password")
                            .placeholder("Et passord")
                            .modify(if: wasIncorrectPassword) {
                                $0.class("is-invalid")
                            }
                    }
                    .invalidFeedback {
                        "Ups! Det var feil passord"
                    }
                    .margin(.three, for: .bottom)

                    Button {
                        "Start prøve"
                    }
                    .type(.submit)
                    .button(style: .primary)
                    .isRounded()
                }
                .method(.post)
                .action(test.enterUri)
            }
        }
    }

}
