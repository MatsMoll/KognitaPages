//
//  NotFoundErrorPage.swift
//  KognitaViews
//
//  Created by Mats Mollestad on 02/12/2019.
//

import BootstrapKit

extension Pages {
    public struct NotFoundError: HTMLPage {

        public init() {}

        public var body: HTML {
            BaseTemplate(context: .init(title: "Ups en feil oppstod", description: "Ups en feil oppstod")) {
                Div {
                    Container {
                        Row {
                            Div {
                                Div {
                                    Anchor {
                                        Span {
                                            LogoImage()
                                        }
                                    }
                                    .href("/")
                                }
                                .class("card-header")
                                .padding(.four, for: .vertical)
                                .text(alignment: .center)
                                .background(color: .primary)

                                Div {
                                    Img().source("/assets/images/startman.svg").height(120).alt("File not found")

                                    Text {
                                        "Ups!"
                                    }
                                    .style(.heading1)

                                    Text {
                                        "Vi klarer ikke finne siden du leter etter"
                                    }
                                    .style(.heading4)
                                    .text(color: .muted)

                                    Anchor {
                                        Italic().class("mdi mdi-reply")
                                        " Returner hjem"
                                    }
                                    .button(style: .info)
                                    .text(color: .white)
                                    .href("/")
                                }
                                .class("card-body")
                                .padding(.four)
                                .text(alignment: .center)
                            }.class("card")
                        }
                        .horizontal(alignment: .center)
                    }
                }.margin(.five, for: .vertical)
            }
        }
    }

}
