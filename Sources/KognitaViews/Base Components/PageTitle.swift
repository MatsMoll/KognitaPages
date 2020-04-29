//
//  PageTitle.swift
//  KognitaViews
//
//  Created by Mats Mollestad on 20/10/2019.
//
// swiftlint:disable multiple_closures_with_trailing_closure

import BootstrapKit

struct PageTitle: HTMLComponent, LocalizableNode {

    let title: HTML
    var breadcrumbs: [BreadcrumbItem] = []

    var breadcrumbItems: [BreadcrumbItem] {
        breadcrumbs + [BreadcrumbItem(link: nil, title: .init(view: title))]
    }

    init(_ localizedKey: String) {
        title = Localized(key: localizedKey)
    }

    init<B>(_ localizedKey: String, with context: TemplateValue<B>) where B: Encodable {
        title = Localized(key: localizedKey, context: context)
    }

    init(title: HTML, breadcrumbs: [BreadcrumbItem] = []) {
        self.title = title
        self.breadcrumbs = breadcrumbs
    }

    var body: HTML {
        Row {
            Div {
                Div {
                    Div {
                        Breadcrumb(
                            items: breadcrumbItems,
                            isActive: { !$0.link.isDefined }
                        ) { item in
                            IF(item.link.isDefined) {
                                Anchor {
                                    item.title
                                }.href(item.link)
                            }.else {
                                item.title
                            }
                        }
                        .margin(.zero)
                    }
                    .class("page-title-right")
                    Text {
                        title
                    }
                    .style(.heading4)
                    .class("page-title")
                }
                .class("page-title-box")
            }
            .column(width: .twelve)
        }
    }
}
