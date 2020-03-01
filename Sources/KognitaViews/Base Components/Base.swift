//
//  Base.swift
//  App
//
//  Created by Mats Mollestad on 06/02/2019.
//
// swiftlint:disable line_length nesting

import HTMLKit
import BootstrapKit
import KognitaCore

struct BaseTemplateContent {
    let title: String
    let description: String

    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
}

struct BaseTemplate: HTMLComponent {

    let context: TemplateValue<BaseTemplateContent>
    let content: HTML
    private var customHeader: HTML = ""
    private var rootUrl: String = ""
    private var customScripts: HTML = ""

    private var stylesheetUrl: String { rootUrl + "/assets/css/app.min.css" }
    private var iconsUrl: String { rootUrl + "/assets/css/icons.min.css" }
    private var faviconUrl: String { rootUrl + "/assets/images/favicon.ico" }

    init(context: TemplateValue<BaseTemplateContent>, @HTMLBuilder content: () -> HTML) {
        self.context = context
        self.content = content()
    }

    init(context: TemplateValue<BaseTemplateContent>, content: HTML, customHeader: HTML, rootUrl: String, scripts: HTML) {
        self.content = content
        self.context = context
        self.customHeader = customHeader
        self.rootUrl = rootUrl
        self.customScripts = scripts
    }

    func scripts(@HTMLBuilder scripts: () -> HTML) -> BaseTemplate {
        BaseTemplate(context: context, content: content, customHeader: customHeader, rootUrl: rootUrl, scripts: scripts())
    }

    func header(@HTMLBuilder header: () -> HTML) -> BaseTemplate {
        BaseTemplate(context: context, content: content, customHeader: header(), rootUrl: rootUrl, scripts: customScripts)
    }

    func rootUrl(_ url: String) -> BaseTemplate {
        BaseTemplate(context: context, content: content, customHeader: customHeader, rootUrl: url, scripts: customScripts)
    }

    var body: HTML {
        Document(type: .html5) {
            Head {
                Viewport(mode: .acordingToDevice)

                Title { context.title + " | Kognita" }
                Description { context.description }
                Author { "Kognita" }

                Stylesheet(url: stylesheetUrl)
                Stylesheet(url: iconsUrl)
                FavIcon(url: faviconUrl)

                customHeader
                // Hotjar tracking
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
            Body {
                content
            }
            .padding(.zero, for: .bottom)
            Script(source: "/assets/js/app.min.js")
            customScripts
        }
        .enviroment(locale: "nb")
    }
}

extension BaseTemplate {
    init(context: BaseTemplateContent, @HTMLBuilder content: () -> HTML) {
        self.context = .constant(context)
        self.content = content()
    }
}
