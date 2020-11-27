//
//  Base.swift
//  App
//
//  Created by Mats Mollestad on 06/02/2019.
//

import HTMLKit
import BootstrapKit

struct BaseTemplateContent {
    let title: String
    let description: String
    let showCookieMessage: Bool

    init(title: String, description: String, showCookieMessage: Bool) {
        self.title = title
        self.description = description
        self.showCookieMessage = showCookieMessage
    }
}

private struct HotjarScript: HTMLComponent {

    var body: HTML {
        Script {
"""
(function(h,o,t,j,a,r){
    h.hj=h.hj||function(){(h.hj.q=h.hj.q||[]).push(arguments)};
    h._hjSettings={hjid:1692974,hjsv:6};
    a=o.getElementsByTagName('head')[0];
    r=o.createElement('script');r.async=1;
    r.src=t+h._hjSettings.hjid+j+h._hjSettings.hjsv;
    a.appendChild(r);
})(window,document,'https://static.hotjar.com/c/hotjar-','.js?sv=');
"""
        }
    }
}

struct Manifest: HTMLComponent {

    let uri: String

    var body: HTML {
        Link().add(HTMLAttribute(attribute: "rel", value: "manifest")).href(uri)
    }
}

struct ScrollSpy {
    let targetID: String
    let offset: Int

    var htmlID: String { "#\(targetID)" }
}

struct NoScript: ContentNode {

    var attributes: [HTMLAttribute]

    let name: String = "noscript"

    let content: HTML

    init(@HTMLBuilder content: () -> HTML) {
        self.content = content()
        self.attributes = []
    }

    init(attributes: [HTMLAttribute], content: HTML) {
        self.attributes = attributes
        self.content = content
    }
}

struct BaseTemplate: HTMLComponent {

    let context: TemplateValue<BaseTemplateContent>
    let content: HTML
    private var customHeader: HTML = ""
    private var rootUrl: String = ""
    private var customScripts: HTML = ""
    private let scrollSpy: ScrollSpy?

    private var stylesheetUrl: String { rootUrl + "/assets/css/app.min.css" }
    private var iconsUrl: String { rootUrl + "/assets/css/icons.min.css" }
    private var faviconUrl: String { rootUrl + "/assets/images/favicon.ico" }

    init(context: TemplateValue<BaseTemplateContent>, @HTMLBuilder content: () -> HTML) {
        self.context = context
        self.content = content()
        self.scrollSpy = nil
    }

    init(context: TemplateValue<BaseTemplateContent>, content: HTML, customHeader: HTML, rootUrl: String, scripts: HTML, scrollSpy: ScrollSpy?) {
        self.content = content
        self.context = context
        self.customHeader = customHeader
        self.rootUrl = rootUrl
        self.customScripts = scripts
        self.scrollSpy = scrollSpy
    }

    func scripts(@HTMLBuilder scripts: () -> HTML) -> BaseTemplate {
        BaseTemplate(context: context, content: content, customHeader: customHeader, rootUrl: rootUrl, scripts: scripts(), scrollSpy: scrollSpy)
    }

    func header(@HTMLBuilder header: () -> HTML) -> BaseTemplate {
        BaseTemplate(context: context, content: content, customHeader: header(), rootUrl: rootUrl, scripts: customScripts, scrollSpy: scrollSpy)
    }

    func rootUrl(_ url: String) -> BaseTemplate {
        BaseTemplate(context: context, content: content, customHeader: customHeader, rootUrl: url, scripts: customScripts, scrollSpy: scrollSpy)
    }

    func scrollSpy(_ scrollSpy: ScrollSpy?) -> BaseTemplate {
        BaseTemplate(context: context, content: content, customHeader: customHeader, rootUrl: rootUrl, scripts: customScripts, scrollSpy: scrollSpy)
    }

    var body: HTML {
        Document(type: .html5) {
            Head {
                Viewport(mode: .acordingToDevice)

                Title { context.title + " | Kognita" }
                Description { context.description }
                Author { "Kognita" }
                Manifest(uri: "/manifest.webmanifest")

                Stylesheet(url: stylesheetUrl)
                Stylesheet(url: iconsUrl)
                FavIcon(url: faviconUrl)

                customHeader
//                HotjarScript()
            }
            Body {
                NoScript {
                    Container {
                        Alert {
                            Text { "Viktig info!" }
                                .style(.heading3)
                            "Denne siden trenger JavaScript for å fungere riktig, og det ser ut som du ikke støtter eller har skrudd av JavaScript."
                        }
                        .background(color: .light)
                        .text(color: .dark)
                        .margin(.two, for: .top)
                        .isDismissable(false)
                    }
                }
                htmlContent
            }
            .padding(.zero, for: .bottom)
            .modify(unwrap: .constant(scrollSpy)) { (spy, body) in
                body
                    .data("spy", value: "scroll")
                    .data("target", value: spy.htmlID)
                    .data("offset", value: spy.offset)
            }

            Script(source: "/assets/js/app.min.js")
            customScripts
            htmlContent.scripts
        }
        .lang("nb")
        .enviroment(locale: "nb")
    }

    // Seperated in order to make the JS beeing added automaticaly
    @HTMLBuilder
    var htmlContent: HTML {
        content
        IF(context.showCookieMessage) {
            CookieMessage()
        }
    }
}

extension BaseTemplate {
    init(context: BaseTemplateContent, @HTMLBuilder content: () -> HTML) {
        self.context = .constant(context)
        self.content = content()
        self.scrollSpy = nil
    }
}
