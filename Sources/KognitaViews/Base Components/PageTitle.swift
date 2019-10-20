//
//  PageTitle.swift
//  KognitaViews
//
//  Created by Mats Mollestad on 20/10/2019.
//

import BootstrapKit

struct PageTitle: StaticView {

    let title: View
    var breadcrumbs: [BreadcrumbItem] = []

    var breadcrumbItems: [BreadcrumbItem] {
        breadcrumbs + [BreadcrumbItem(link: nil, title: .init(view: title))]
    }

    var body: View {
        Row {
            Div {
                Div {
                    Div {
                        Breadcrumb(items: breadcrumbItems, isActive: { !$0.link.isDefined }) { item in
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
                    H4 {
                        title
                    }
                    .class("page-title")
                }
                .class("page-title-box")
            }
            .column(width: .twelve)
        }
    }
}
