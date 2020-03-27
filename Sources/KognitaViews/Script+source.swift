import BootstrapKit

extension Script {
    init(source: String) {
        self.init()
        attributes = [
            HTMLAttribute(attribute: "src", value: source),
            HTMLAttribute(attribute: "type", value: "text/javascript"),
        ]
    }
}

extension Script {
    static let autoResizeTextAreas: String =
"""
var observe;
if (window.attachEvent) {
    observe = function (element, event, handler) {
        element.attachEvent('on'+event, handler);
    };
}
else {
    observe = function (element, event, handler) {
        element.addEventListener(event, handler, false);
    };
}
function initTextArea() {
Array.from(document.getElementsByTagName("textarea")).forEach(function (text, index) {
    function resize () {
        text.style.height = 'auto';
        text.style.height = text.scrollHeight+'px';
    }
    /* 0-timeout to get the already changed text */
    function delayedResize () {
        window.setTimeout(resize, 0);
    }
    observe(text, 'change',  resize);
    observe(text, 'cut',     delayedResize);
    observe(text, 'paste',   delayedResize);
    observe(text, 'drop',    delayedResize);
    observe(text, 'keydown', delayedResize);

    text.focus();
    text.select();
    resize();
})
}
initTextArea();
"""
}
