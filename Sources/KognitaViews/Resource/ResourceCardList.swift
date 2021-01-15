//
//  ResourceCardList.swift
//  
//
//  Created by Mats Mollestad on 15/01/2021.
//

import Foundation

public struct ResourceCardList: HTMLTemplate {
    
    public init() {}
    
    public struct Context {
        let resources: [ResourceViewModel]
        
        public init(resources: [Resource]) {
            let allResources = resources.map { $0.viewModel }
            var hosts = Set<String>()
            self.resources = allResources.filter { resource in
                guard
                    let rawUrl = resource.url,
                    let components = URLComponents(string: rawUrl.url),
                    let host = components.host
                else { return true }
                
                var basePath = host + components.path + (components.query ?? "")
                if basePath.hasSuffix("/") {
                    basePath.removeLast()
                }
                if hosts.contains(basePath) {
                    return false
                } else {
                    hosts.insert(basePath)
                    return true
                }
            }
        }
    }
    
    public var body: HTML {
        IF(context.resources.isEmpty) {
            Text {
                "Vi har ingen registrerte ressurser 😔"
            }
            .style(.heading4)
        }.else {
            Row {
                ForEach(in: context.resources) { resource in
                    Div {
                        Card { ResourceRow(resource: resource) }
                            .class("border border-light")
                    }
                    .column(width: .six, for: .large)
                }
            }
        }
    }
}
