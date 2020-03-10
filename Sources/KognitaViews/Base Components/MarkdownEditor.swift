import BootstrapKit

struct MarkdownEditor: HTMLComponent, AttributeNode, PlaceholderAttribute, FormInput {

    var attributes: [HTMLAttribute]

    public init(id: String) {
        attributes = [HTMLAttribute(attribute: "id", value: id)]
    }

    private init(attributes: [HTMLAttribute]) {
        self.attributes = attributes
    }

    private var id: String {
        guard let id = value(of: "id") as? String else {
            return "markdown-editor"
        }
        return id
    }

    var body: HTML {
        let filteredAttributes = attributes.filter({ $0.attribute != "id" })

        return TextArea().add(attributes: filteredAttributes).id(id)
    }

    func copy(with attributes: [HTMLAttribute]) -> MarkdownEditor {
        .init(attributes: attributes)
    }

    var scripts: HTML {
        let jsId = id.replacingOccurrences(of: "-", with: "")

        return NodeList {
            Script {
"""
\(jsId) = new SimpleMDE({
    element: document.getElementById("\(id)"),
    spellChecker: false,
    toolbar: [
        "bold",
        "italic",
        "heading",
        "|",
        "code",
        "quote",
        "unordered-list",
        "ordered-list",
        "|",
        "link",
        "image",
        {
            name: "LaTeX",
            action: function (editor) {
                var text = editor.value();
                text += "$$$$";
                editor.value(text);
                let cm = editor.codemirror;
                var startPoint = cm.getCursor('start');
                var endPoint = cm.getCursor('end');
                startPoint.ch += 2;
                endPoint.ch += 2;
                cm.setSelection(startPoint, endPoint);
                cm.focus();
            },
            className: "fa fa-calculator",
            title: "LaTeX",
        },
        "|",
        "preview",
        "guide"
    ],
    previewRender: function(text) {
        return this.parent.markdown(renderKatex(text));
    }
});
"""
            }
        }
    }
}
