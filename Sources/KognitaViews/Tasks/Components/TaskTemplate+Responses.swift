import BootstrapKit
import KognitaCore


extension TaskPreviewTemplate {

    public struct Responses: HTMLTemplate {

        public typealias Context = [TaskDiscussion.Pivot.Response.Details]

        public var body: HTML {
            Text {
                ForEach(in: context) { (response: TemplateValue<TaskDiscussion.Pivot.Response.Details>) in
                    Text {
                        response.response
                    }
                    
                    Text {
                        response.username
                    }
                }
            }
        }
    }
}
