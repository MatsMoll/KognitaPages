//
//  EditPasswordPage.swift
//  KognitaViews
//
//  Created by Eskild Brobak on 13/02/2020.
//

import BootstrapKit
import KognitaCore

extension User.Templates {
    public struct EditPassword: HTMLTemplate {

        public struct Context {
            let token: String

            public init(token: String) {
                self.token = token
            }
        }

        public var body: HTML {
            ""
        }
    }
}
