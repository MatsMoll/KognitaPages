import KognitaCore
import BootstrapKit

extension SubjectTest {
    public enum Templates {}
}

extension SubjectTest.Templates {
    struct StartModal: HTMLComponent {

        let test: TemplateValue<SubjectTest.OverviewResponse>

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
                    }
                    .margin(.three, for: .bottom)

                    Button {
                        "Start test"
                    }
                    .type(.submit)
                    .button(style: .primary)
                    .isRounded()
                }
                .method(.post)
                .action("/subject-tests/" + test.id + "/enter")
            }
        }
    }

}
