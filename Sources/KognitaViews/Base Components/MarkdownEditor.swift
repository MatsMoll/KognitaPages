import BootstrapKit

struct MarkdownEditor: HTMLComponent, AttributeNode, PlaceholderAttribute, FormInput {

    var attributes: [HTMLAttribute]
    var content: HTML
    private var onChange: ((String) -> String)?

    public init(id: String) {
        attributes = [HTMLAttribute(attribute: "id", value: id)]
        content = ""
    }

    public init(id: String, @HTMLBuilder content: () -> HTML) {
        attributes = [HTMLAttribute(attribute: "id", value: id)]
        self.content = content()
    }

    private init(attributes: [HTMLAttribute], onChange: ((String) -> String)?, content: HTML) {
        self.attributes = attributes
        self.onChange = onChange
        self.content = content
    }

    private var id: String {
        guard let id = value(of: "id") as? String else { return "markdown-editor" }
        return id
    }

    var body: HTML {
        let filteredAttributes = attributes.filter({ $0.attribute != "id" })

        return TextArea { content }.add(attributes: filteredAttributes).id(id)
    }

    func copy(with attributes: [HTMLAttribute]) -> MarkdownEditor {
        .init(attributes: attributes, onChange: onChange, content: content)
    }

    func onChange(_ onChange: @escaping (String) -> String) -> MarkdownEditor {
        .init(attributes: attributes, onChange: onChange, content: content)
    }

    var scripts: HTML {
        let jsId = id.replacingOccurrences(of: "-", with: "")
        var onChangeScript = ""
        if let onChange = onChange {
            onChangeScript = "\(jsId).codemirror.on(\"change\", function(){\(onChange(jsId))});"
        }

        return NodeList {
            Script {
"""
\(jsId) = new SimpleMDE({
    element: document.getElementById("\(id)"),
    spellChecker: false,
    toolbar: ["bold","italic","heading","|","code","quote","unordered-list","ordered-list","|","link","image",{name: "LaTeX",action: function (editor) {var text = editor.value();text += "$$\\\\frac{1}{2}$$";editor.value(text);},className: "fa fa-calculator",title: "LaTeX",},"|","preview","guide"],
    renderingConfig: { codeSyntaxHighlighting: true,},
    status: [{ className: "ord", defaultValue: function(e){this.words=0;e.innerHTML="0 ord";}, onUpdate: function(e){e.innerHTML=\(jsId).value().split(/\\s+/).length;} }],
    promptURLs: true,
    previewRender: function(text) { return renderMarkdown(text); }
});\(onChangeScript)
"""
            }
        }
    }
}
