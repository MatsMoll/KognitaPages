//
//  ResourceList.swift
//  
//
//  Created by Mats Mollestad on 05/01/2021.
//

import Foundation

struct ResourceList: HTMLComponent {
    
    let resources: TemplateValue<[ResourceViewModel]>
    
    var body: HTML {
        CollapsingCard {
            Text { "Ressurser" }.style(.heading4)
        }
        .content {
            Div {
                ForEach(in: resources) { resource in
                    Div {
                        ResourceRow(resource: resource)
                    }
                    .padding(.three, for: .horizontal)
                    .class("border-top border-light")
                }
            }
        }
        .isShown(true)
    }
}
