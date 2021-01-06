//
//  ResourceCard.swift
//
//
//  Created by Mats Mollestad on 04/01/2021.
//

import Foundation

public struct ResourceViewModel {
    
    public struct URLDescription {
        
        let url: String
        let callToAction: String
        
        public init(url: String, callToAction: String) {
            self.url = url
            self.callToAction = callToAction
        }
    }
    
    let icon: MaterialDesignIcon.Icons
    let url: URLDescription?
    
    let title: String
    let secondaryTitle: String
    let tetriaryTitle: String?
    let quartileTitle: String?
    
    public init(icon: MaterialDesignIcon.Icons, url: ResourceViewModel.URLDescription?, title: String, secondaryTitle: String, tetriaryTitle: String? = nil, quartileTitle: String? = nil) {
        self.icon = icon
        self.url = url
        self.title = title
        self.secondaryTitle = secondaryTitle
        self.tetriaryTitle = tetriaryTitle
        self.quartileTitle = quartileTitle
    }
}

extension Anchor {
    func openInNewTab() -> Self {
        self.add(.init(attribute: "target", value: "_blank"))
            .relationship(.noOpener)
            .relationship(.noReferrer)
    }
}

struct ResourceRow: HTMLComponent {
    
    let resource: TemplateValue<ResourceViewModel>
    
    var body: HTML {
        Row {
            Row {
                Text { MaterialDesignIcon(resource.icon) }
                    .style(.display4)
                    .display(.inlineBlock)
                
                Div {
                    Text { resource.title }
                        .style(.cardTitle)
                        .text(color: .dark)
                    
                    Text { resource.secondaryTitle }
                        .style(.cardSubtitle)
                        .text(color: .dark)

                    
                    Unwrap(resource.tetriaryTitle) { title in
                        Text { title }
                            .style(.cardText)
                            .text(color: .dark)
                    }
                    
                    Unwrap(resource.quartileTitle) { title in
                        Text { title }
                            .style(.cardText)
                            .text(color: .secondary)
                    }
                }
                .display(.inlineBlock)
                .text(break: .break)
            }
            .margin(.zero, for: .horizontal)
            .alignment(.itemsCenter)
            
            Unwrap(resource.url) { url in
                Anchor { url.callToAction }
                    .button(style: .light)
                    .href(url.url)
                    .openInNewTab()
                    .margin(.two, for: .vertical)
            }
        }
        .margin(.zero, for: .horizontal)
        .alignment(.itemsCenter)
        .horizontal(alignment: .between)
    }
}
